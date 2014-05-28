import win32crypt
import binascii
import sys

try:
  password = unicode(sys.argv[1])
except:
  password = u'123456'

pwdHash = win32crypt.CryptProtectData(password, u'psw', None, None, None, 0)

print binascii.hexlify(pwdHash)
