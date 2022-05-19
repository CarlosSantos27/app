# futgolazo_main_app

Aplicación de Futgolazo

# METODOS KEY HASH KEY STORE COMANDOS

//GENERAR KEY HASH COMO DEVELOPER

keytool -exportcert -alias androiddebugkey -keystore "C:\Users\alfao\.android\debug.keystore" | "C:\openssl\bin\openssl" sha1 -binary | "C:\openssl\bin\openssl" base64

# GENERAR KEY HASH PARA APP

keytool -exportcert -alias Futgolazo -keystore C:\Users\alfao\key.jks | "C:\openssl\bin\openssl" sha1 -binary | "C:\openssl\bin\openssl" base64

# GENERAR KEYSTORE

keytool -genkey -v -keystore C:\Users\alfao\key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias Futgolazo

clave de keystrore ESTA EN EL PASSBOLD

# GENERAR GPG FILE

gpg -c "nombre del archivo" con nuestro archivo key.jks, gpg -c keys.jks

# PARA GOOGLE 
keytool -exportcert -list -v -alias <your-key-name> -keystore <path-to-production-keystore>