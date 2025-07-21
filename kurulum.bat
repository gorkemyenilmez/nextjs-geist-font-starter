@echo off
echo ================================================
echo   PERFORMANS OPTIMIZASYON ARACI - KURULUM
echo   LOGO Yazilim SQL Server Performans Araci
echo ================================================
echo.

:: Node.js kontrolü
echo [1/5] Node.js kontrol ediliyor...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo HATA: Node.js bulunamadi!
    echo Lutfen Node.js'i yukleyin: https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js bulundu: 
node --version

:: NPM kontrolü
echo.
echo [2/5] NPM kontrol ediliyor...
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo HATA: NPM bulunamadi!
    pause
    exit /b 1
)

echo NPM bulundu: 
npm --version

:: Bağımlılıkları yükleme
echo.
echo [3/5] Bagimliliklari yukleniyor...
echo Bu islem birkaç dakika surebilir...
npm install --legacy-peer-deps
if %errorlevel% neq 0 (
    echo HATA: Bagimliliklari yuklenemedi!
    pause
    exit /b 1
)

:: Uygulamayı derleme
echo.
echo [4/5] Uygulama derleniyor...
npm run build
if %errorlevel% neq 0 (
    echo HATA: Uygulama derlenemedi!
    pause
    exit /b 1
)

:: Kurulum tamamlandı
echo.
echo [5/5] Kurulum tamamlandi!
echo.
echo ================================================
echo   KURULUM BASARILI!
echo ================================================
echo.
echo Uygulamayi baslatmak icin:
echo   npm run dev        (Gelistirme modu)
echo   npm run production (Uretim modu)
echo.
echo Uygulama adresi: http://localhost:8000
echo.
echo Baslatmak icin herhangi bir tusa basin...
pause >nul

:: Uygulamayı başlat
echo Uygulama baslatiliyor...
start http://localhost:8000
npm run dev
