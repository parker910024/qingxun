//
//  TEACrypto.mm
//  YY2
//
//  Created by wuwei on 14-4-2.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import "TEACrypto.h"
#include <iostream>
#include <assert.h>

class TEAInternal
{
public:
	static void TEA_Encrypt(const std::string& strIn, const std::string& key, std::string& strOut, int round);
	static void TEA_Encrypt(const char* strIn, size_t len, const std::string& key, std::string& strOut, int round);
    
	static void TEA_Decrypt(const std::string& strIn, const std::string& key, std::string& strOut, int round);
	static void TEA_Decrypt(const char* strIn, size_t len, const std::string& key, std::string& strOut, int round);
};


@implementation TEACrypto

+ (NSData *)encryptData:(NSData *)data usingKey:(NSData *)key
{
    if (key.length == 0) {
        return data;
    }
    
    NSMutableData *result = [NSMutableData data];
    char *ckey = new char[key.length + 1];
    memcpy(ckey, key.bytes, key.length);
    ckey[key.length] = 0;
    
    char *pData = (char *)data.bytes;
    NSInteger lengthRemaining = data.length;
    NSInteger lengthToEncrypt;
    while (lengthRemaining > 0) {
        lengthToEncrypt = lengthRemaining > 1024 ? 1024 : lengthRemaining;
        
        std::string strEnc;
        TEAInternal::TEA_Encrypt(pData, lengthToEncrypt, ckey, strEnc, 64);
        if (strEnc.size() > 0) {
            [result appendBytes:strEnc.data() length:sizeof(std::string::traits_type::char_type)*strEnc.size()];
        }
        
        pData += lengthToEncrypt;
        lengthRemaining -= lengthToEncrypt;
    }
    delete ckey;
    return [NSData dataWithData:result];
}

+ (NSData *)decryptData:(NSData *)data usingKey:(NSData *)key
{
    if (key.length == 0) {
        return data;
    }
    
    NSMutableData *result = [NSMutableData data];
    char *ckey = new char[key.length + 1];
    memcpy(ckey, key.bytes, key.length);
    ckey[key.length] = 0;
    
    char *pData = (char *)data.bytes;
    NSInteger lengthRemaining = data.length;
    NSInteger lengthToDecrypt;
    while (lengthRemaining > 0) {
        lengthToDecrypt = lengthRemaining > 1024 ? 1024 : lengthRemaining;
        
        std::string strDec;
        TEAInternal::TEA_Decrypt(pData, lengthToDecrypt, ckey, strDec, 64);
        if (strDec.size() > 0) {
            [result appendBytes:strDec.data() length:sizeof(std::string::traits_type::char_type)*strDec.size()];
        }
        
        pData += lengthToDecrypt;
        lengthRemaining -= lengthToDecrypt;
    }
    delete ckey;
    return [NSData dataWithData:result];
}

+ (NSData *)encryptFileAtPath:(NSString *)filePath usingKey:(NSData *)key
{
    NSMutableData *ret = [NSMutableData data];
    
    if ([filePath length] > 0 && [key length] > 0) {
        char buf[1024];
        size_t len = 0;
        
        FILE* fpIn = fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "r");
        char *ckey = new char[key.length + 1];
        memcpy(ckey, key.bytes, key.length);
        ckey[key.length] = 0;
        
        if (fpIn != NULL ) {
            do
            {
                len = fread(buf, sizeof(std::string::traits_type::char_type), 1024, fpIn);
                if(len <= 0) {
                    break;
                }
                
                std::string strEnc;
                TEAInternal::TEA_Encrypt(buf, len, ckey, strEnc, 64);
                
                if (strEnc.size() > 0) {
                    [ret appendBytes:strEnc.data() length:sizeof(std::string::traits_type::char_type)*strEnc.size()];
                }
                
            } while(!feof(fpIn));
        }
        fclose(fpIn);
        delete ckey;
    }
    else
    {
        NSLog(@"encode TEA failed for no fileName or key");
    }
    return [NSData dataWithData:ret];
}

+ (NSData *)decryptFileAtPath:(NSString *)filePath usingKey:(NSData *)key
{
    NSMutableData *ret = [NSMutableData data];
    
    if ([filePath length] > 0 && [key length] > 0) {
        char buf[1024];
        size_t len = 0;
        
        FILE* fpIn = fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "r");
        char *ckey = new char[key.length + 1];
        memcpy(ckey, key.bytes, key.length);
        ckey[key.length] = 0;
        
        if (fpIn != NULL ) {
            do
            {
                len = fread(buf, sizeof(std::string::traits_type::char_type), 1024, fpIn);
                if(len <= 0) {
                    break;
                }
                
                std::string strDec;
                TEAInternal::TEA_Decrypt(buf, len, ckey, strDec, 64);
                
                if (strDec.size() > 0) {
                    [ret appendBytes:strDec.data() length:sizeof(std::string::traits_type::char_type)*strDec.size()];
                }
                
            } while(!feof(fpIn));
        }
        
        fclose(fpIn);
        delete ckey;
    } else {
        NSLog(@"decodeTEA failed for no fileName or key");
    }
    
	return [NSData dataWithData:ret];
}

@end


#pragma mark - TEAInternal

const size_t KTEAVGranularitySize = sizeof(unsigned long) * 2;
const size_t KTEAKeySize = sizeof(unsigned long) * 4;

static std::string TEAEncryptImpl( const char *data, size_t length, const std::string &key, int round )
{
	std::string result;
	if (length < KTEAVGranularitySize)
	{
		result.append(data, length);
		return result;
	}
	//÷ª÷ß≥÷16,32,64¬÷»˝÷÷
	if ( 16 != round && 32 != round && 64 != round )
	{
		assert(false);
		result.append(data, length);
		return result;
	}
    
	unsigned long value_Long[2] = {0};
	memcpy(value_Long, data, length < KTEAVGranularitySize ? length : KTEAVGranularitySize);
	unsigned long key_Long[4] = {0};
	memcpy(key_Long, key.data(), key.length() < KTEAKeySize ? key.length() : KTEAKeySize);
    
	unsigned long y = value_Long[0], z = value_Long[1], sum = 0;
	unsigned long delta = 0x9e3779b9;                 /* a keyey schedule constant */
	unsigned long a = key_Long[0], b = key_Long[1], c = key_Long[2], d = key_Long[3];   /* cache keyey */
    
	for ( int i = 0; i < round; i++ )
	{                        /* basic cycle start */
		sum += delta;
		y += ((z<<4) + a) ^ (z + sum) ^ ((z>>5) + b);
		z += ((y<<4) + c) ^ (y + sum) ^ ((y>>5) + d);/* end cycle */
	}
    
	value_Long[0]=y;
	value_Long[1]=z;
    
	result.append((const char *)value_Long, sizeof(value_Long));
	return result;
}

static std::string TEADecryptImpl( const char *data, size_t length, const std::string &key, int round )
{
	std::string result;
	if (length < KTEAVGranularitySize)
	{
		result.append(data, length);
		return result;
	}
	//÷ª÷ß≥÷16,32,64¬÷»˝÷÷
	if ( 16 != round && 32 != round && 64 != round )
	{
		assert(false);
		result.append(data, length);
		return result;
	}
    
	unsigned long value_Long[2] = {0};
	memcpy(value_Long, data, length < KTEAVGranularitySize ? length : KTEAVGranularitySize);
	unsigned long key_Long[4] = {0};
	memcpy(key_Long, key.data(), key.length() < KTEAKeySize ? key.length() : KTEAKeySize);
    
	unsigned long y = value_Long[0], z = value_Long[1], sum = 0xC6EF3720; /* set up */
	unsigned long delta = 0x9e3779b9;                  /* a key_Longey schedule constant */
	unsigned long a = key_Long[0], b = key_Long[1], c = key_Long[2], d = key_Long[3];    /* cache key_Longey */
	if ( 32 == round )
	{
		sum = 0xC6EF3720; /* delta << 5*/
	}
	else if ( 16 == round )
	{
		sum = 0xE3779B90; /* delta << 4*/
	}
	else
	{
		sum = delta * round;
	}
    
	for(int i = 0; i < round; i++)
	{                            /* basic cycle start */
		z -= ((y<<4) + c) ^ (y + sum) ^ ((y>>5) + d);
		y -= ((z<<4) + a) ^ (z + sum) ^ ((z>>5) + b);
		sum -= delta;                                /* end cycle */
	}
	value_Long[0] = y;
	value_Long[1] = z;
    
	result.append((const char *)value_Long, sizeof(value_Long));
	return result;
}

void TEAInternal::TEA_Encrypt(const std::string& strIn, const std::string& key, std::string& strOut, int round)
{
	for ( std::string::size_type pos = 0; pos < strIn.size(); pos += KTEAVGranularitySize)
	{
		strOut.append(TEAEncryptImpl(strIn.c_str() + pos, strIn.length() - pos, key, round));
	}
}

void TEAInternal::TEA_Encrypt(const char* strIn, size_t len, const std::string& key, std::string& strOut, int round)
{
	for ( size_t pos = 0; pos < len; pos += KTEAVGranularitySize )
	{
		strOut.append(TEAEncryptImpl(strIn + pos, len - pos, key, round));
	}
}

void TEAInternal::TEA_Decrypt(const std::string& strIn, const std::string& key, std::string& strOut, int round)
{
	for ( std::string::size_type pos = 0; pos < strIn.size(); pos += KTEAVGranularitySize )
	{
		strOut.append(TEADecryptImpl(strIn.c_str() + pos, strIn.length() - pos, key, round));
	}
}

void TEAInternal::TEA_Decrypt(const char* strIn, size_t len, const std::string& key, std::string& strOut, int round)
{
	for ( size_t pos = 0; pos < len; pos += KTEAVGranularitySize )
	{
		strOut.append(TEADecryptImpl(strIn + pos, len - pos, key, round));
	}
}
