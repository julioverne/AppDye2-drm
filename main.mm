#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
OBJC_EXTERN CFStringRef MGCopyAnswer(CFStringRef key) WEAK_IMPORT_ATTRIBUTE;


@implementation NSString (HMAC)
+ (NSString *)encodeBase64WithString:(NSString *)strData {
    return [self encodeBase64WithData:[strData dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (NSString*)encodeBase64WithData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;

            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
+ (NSString *)hmacSHA256BinBase64:(NSString *)data withKey:(NSString *)key 
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    return [NSString encodeBase64WithData:HMAC];
}
@end

int main()
{
	system("rm -rf /private/var/mobile/Library/Preferences/com.baileyseymour.appdye2.license");
	
	NSFileManager *manager = [[NSFileManager alloc] init];
	
	NSString *pref_lice = @"/private/var/mobile/Library/Preferences/com.baileyseymour.appdye2.license";
	
	CFStringRef UDID = MGCopyAnswer(CFSTR("UniqueDeviceID"));
	
	NSString* keyreg = [[NSString hmacSHA256BinBase64:[NSString stringWithFormat:@"1%@", (NSString *)UDID] withKey:@"Taepotmranfadtvimhaas#!;"] copy];
	
	NSMutableDictionary *pref_liceCheck = [[NSMutableDictionary alloc] initWithContentsOfFile:pref_lice]?:[NSMutableDictionary dictionary];
	[pref_liceCheck setObject:keyreg forKey:@"data"];
	[pref_liceCheck setObject:@NO forKey:@"has_restarted"];
	[pref_liceCheck setObject:@"1cb86f668c4ad281f48349201db2b03f86445724" forKey:@"key"];
	
	if ([pref_liceCheck writeToFile:pref_lice atomically:YES]) {
		[manager setAttributes:@{NSFileOwnerAccountName:@"mobile", NSFileGroupOwnerAccountName:@"mobile", NSFilePosixPermissions:@0644, } ofItemAtPath:pref_lice error:nil];
		printf("\n*** License has been generated! ***\n");
	} else {
		printf("\n*** Error writing license to file! ***\n");		
	}
	
	printf("\n");
	printf("Respring!!!\n");
	printf("Respring!!!\n");
	printf("Respring!!!\n");
	printf("\n");
	printf("*** Keygen AppDye2 by julioverne ***\n");
	printf("\n");
}