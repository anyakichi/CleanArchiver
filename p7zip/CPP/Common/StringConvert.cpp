// Common/StringConvert.cpp

#include "StdAfx.h"
#include <stdlib.h>

#include "StringConvert.h"
extern "C"
{
int global_use_utf16_conversion = 0;
}

namespace utf8
{
#include "UTFConvert.cpp"
}


#ifdef LOCALE_IS_UTF8

#ifdef ENV_MACOSX
namespace mac
{
#include <CoreFoundation/CFString.h>
}
#endif

UString MultiByteToUnicodeString(const AString &srcString, UINT codePage)
{
  if ((global_use_utf16_conversion) && (!srcString.IsEmpty()))
  {
#ifdef ENV_MACOSX
    UString resultString;
    mac::CFStringRef string;
    mac::CFMutableStringRef mutableString;
    mac::UniChar *utf16String;
    int len;
    const char *src = srcString;

    string = mac::CFStringCreateWithBytes(NULL, (const mac::UInt8 *)src,
					  strlen(src),
					  mac::kCFStringEncodingUTF8, false);
    if (string == NULL)
      goto fail1;
    mutableString = mac::CFStringCreateMutableCopy(NULL, 0, string);
    if (mutableString == NULL)
      goto fail2;

    mac::CFStringNormalize(mutableString, mac::kCFStringNormalizationFormC);
    len = mac::CFStringGetLength(mutableString);

    utf16String = (mac::UniChar *)malloc(len * sizeof(mac::UniChar));
    if (utf16String == NULL)
      goto fail3;

    mac::CFStringGetCharacters(mutableString, mac::CFRangeMake(0, len),
			       utf16String);

    for (int i = 0; i < len; i++)
      resultString += utf16String[i];

    free(utf16String);
fail3:
    CFRelease(mutableString);
fail2:
    CFRelease(string);
fail1:

    if (!resultString.IsEmpty())
      return resultString;
#else /* ENV_MACOSX */
    UString resultString;
    bool bret = utf8::ConvertUTF8ToUnicode(srcString,resultString);
    if (bret) return resultString;
#endif /* ENV_MACOSX */
  }

  UString resultString;
  for (int i = 0; i < srcString.Length(); i++)
    resultString += wchar_t(srcString[i] & 255);

  return resultString;
}

AString UnicodeStringToMultiByte(const UString &srcString, UINT codePage)
{
  if ((global_use_utf16_conversion) && (!srcString.IsEmpty()))
  {
#ifdef ENV_MACOSX
    AString resultString;
    mac::CFStringRef string;
    mac::CFMutableStringRef mutableString;
    mac::UniChar *utf16String;
    const wchar_t *src;
    char *dst;
    int len, max;

    src = srcString;
    len = wcslen(src);

    utf16String = (mac::UniChar *)malloc(len * sizeof(mac::UniChar));
    if (utf16String == NULL)
      goto fail1;

    for (int i = 0; i < len; i++)
      utf16String[i] = src[i];

    string = mac::CFStringCreateWithCharacters(NULL, utf16String, len);
    if (string == NULL)
      goto fail2;

    mutableString = mac::CFStringCreateMutableCopy(NULL, 0, string);
    if (mutableString == NULL)
      goto fail3;

    mac::CFStringNormalize(mutableString, mac::kCFStringNormalizationFormD);
    max = mac::CFStringGetMaximumSizeForEncoding(len,
						 mac::kCFStringEncodingUTF8);

    dst = resultString.GetBuffer(max);
    mac::CFStringGetCString(mutableString, dst, max,
			    mac::kCFStringEncodingUTF8);
    resultString.ReleaseBuffer();

    mac::CFRelease(mutableString);
fail3:
    mac::CFRelease(string);
fail2:
    free(utf16String);
fail1:

    if (!resultString.IsEmpty())
      return resultString;
#else /* ENV_MACOSX */
    AString resultString;
    bool bret = utf8::ConvertUnicodeToUTF8(srcString,resultString);
    if (bret) return resultString;
#endif /* ENV_MACOSX */
  }

  AString resultString;
  for (int i = 0; i < srcString.Length(); i++)
  {
    if (srcString[i] >= 256) resultString += '?';
    else                     resultString += char(srcString[i]);
  }
  return resultString;
}

#else /* LOCALE_IS_UTF8 */

UString MultiByteToUnicodeString(const AString &srcString, UINT codePage)
{
#ifdef HAVE_MBSTOWCS
  if ((global_use_utf16_conversion) && (!srcString.IsEmpty()))
  {
    UString resultString;
    int numChars = mbstowcs(resultString.GetBuffer(srcString.Length()),srcString,srcString.Length()+1);
    if (numChars >= 0) {
      resultString.ReleaseBuffer(numChars);
      return resultString;
    }
  }
#endif

  UString resultString;
  for (int i = 0; i < srcString.Length(); i++)
    resultString += wchar_t(srcString[i] & 255);

  return resultString;
}

AString UnicodeStringToMultiByte(const UString &srcString, UINT codePage)
{
#ifdef HAVE_WCSTOMBS
  if ((global_use_utf16_conversion) && (!srcString.IsEmpty()))
  {
    AString resultString;
    int numRequiredBytes = srcString.Length() * 6+1;
    int numChars = wcstombs(resultString.GetBuffer(numRequiredBytes),srcString,numRequiredBytes);
    if (numChars >= 0) {
      resultString.ReleaseBuffer(numChars);
      return resultString;
    }
  }
#endif

  AString resultString;
  for (int i = 0; i < srcString.Length(); i++)
  {
    if (srcString[i] >= 256) resultString += '?';
    else                     resultString += char(srcString[i]);
  }
  return resultString;
}

#endif /* LOCALE_IS_UTF8 */

