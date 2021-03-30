#!/bin/sh


# Clean directory
rm -rf build
mkdir build
mkdir build/libs
mkdir build/deploy
mkdir build/artifacts
mkdir build/production
mkdir build/production/data


# Unzip dependency jars
tar -zxf /Applications/Processing.app/Contents/Java/core/library/core.jar -C build/production/
tar -zxf /Applications/Processing.app/Contents/Java/core/library/gluegen-rt-natives-macosx-universal.jar -C build/production/
tar -zxf /Applications/Processing.app/Contents/Java/core/library/gluegen-rt.jar -C build/production/
tar -zxf /Applications/Processing.app/Contents/Java/core/library/jogl-all-natives-macosx-universal.jar -C build/production/
tar -zxf /Applications/Processing.app/Contents/Java/core/library/jogl-all.jar -C build/production/
tar -zxf /Applications/Processing.app/Contents/Java/modes/java/libraries/serial/library/serial.jar -C build/production/
tar -zxf /Applications/Processing.app/Contents/Java/modes/java/libraries/net/library/net.jar -C build/production/


# Download jSSC (Java Simple Serial Connector). This version fixes some connection issues
curl -L -o build/libs/jSSC-2.7.0-Release.zip https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/java-simple-serial-connector/jSSC-2.7.0-Release.zip
tar -zxf build/libs/jSSC-2.7.0-Release.zip -C build/libs/
tar -zxf build/libs/jSSC-2.7.0-Release/jssc.jar -C build/production/


# Download ControlP5. This version fixes some retina issues
curl -L -o build/libs/controlP5-2.2.6.zip https://github.com/sojamo/controlp5/releases/download/v2.2.6/controlP5-2.2.6.zip
tar -zxf build/libs/controlP5-2.2.6.zip -C build/libs/
tar -zxf build/libs/controlP5/library/controlP5.jar -C build/production/


# Copy assets
cp -r assets/data/ build/production/data/
cp -r assets/icon/icon-16.png build/production/icon/
cp -r assets/icon/icon-32.png build/production/icon/
cp -r assets/icon/icon-48.png build/production/icon/
cp -r assets/icon/icon-64.png build/production/icon/
cp -r assets/icon/icon-128.png build/production/icon/
cp -r assets/icon/icon-256.png build/production/icon/
cp -r assets/icon/icon-512.png build/production/icon/
cp -r assets/icon/icon-1024.png build/production/icon/
cp -r assets/icon/icon.icns build/production/icon/


# Copy manifest
cp -r src/META-INF/MANIFEST.MF build/production/META-INF/MANIFEST.MF


# Compile JAVA to classes
javac -sourcepath src -classpath "build/libs/controlP5/library/controlP5.jar:build/libs/jSSC-2.7.0-Release/jssc.jar:/Applications/Processing.app/Contents/Java/core/library/core.jar:/Applications/Processing.app/Contents/Java/core/library/gluegen-rt-natives-macosx-universal.jar:/Applications/Processing.app/Contents/Java/core/library/gluegen-rt.jar:/Applications/Processing.app/Contents/Java/core/library/jogl-all-natives-macosx-universal.jar:/Applications/Processing.app/Contents/Java/core/library/jogl-all.jar:/Applications/Processing.app/Contents/Java/modes/java/libraries/serial/library/serial.jar:/Applications/Processing.app/Contents/Java/modes/java/libraries/net/library/net.jar" -d build/production/ src/com/AfvanJaffer/easy/Main.java


# Create JAR
jar -cvfm build/artifacts/easy.jar build/production/META-INF/MANIFEST.MF -C build/production/ .


# Make an executable JAR file
javapackager -createjar -appclass com.AfvanJaffer.easy.Main -srcdir build/artifacts/ -srcfiles easy.jar -outdir build/artifacts/ -outfile easy.jar


# Codesign JAR
# jarsigner -storetype pkcs12 -keystore keystore.pfx build/artifacts/easy.jar "Ferdi Koomen"
# jarsigner -verify build/artifacts/easy.jar


# Package the JAR and JAVA runtime as a native application with installer
javapackager -deploy -appclass com.AfvanJaffer.easy.Main -srcdir build/artifacts/ -srcfiles easy.jar -outdir build/deploy -outfile easy -native image -name easy -Bruntime="/Library/Java/JavaVirtualMachines/jdk1.8.0_201.jdk/Contents/Home/jre" -Bicon="build/production/icon/icon.icns"


# Codesign application
codesign --force --deep --verbose --sign "Developer ID Application: Ferdi Koomen" build/deploy/bundles/easy.app
codesign --verbose --verify build/deploy/bundles/easy.app


# Build a DMG file
dmgcanvas installer/installer.dmgCanvas build/deploy/bundles/easy.dmg


# Code sign DMG file
codesign --verbose --sign "Developer ID Application: Ferdi Koomen" build/deploy/bundles/easy.dmg
codesign --verbose --verify build/deploy/bundles/easy.dmg
