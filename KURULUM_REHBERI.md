# Performans Optimizasyon Aracı - Kurulum Rehberi

## 📋 Sistem Gereksinimleri

### Minimum Gereksinimler:
- **İşletim Sistemi**: Windows 10/11, macOS 10.15+, Ubuntu 18.04+
- **Node.js**: v18.17.0 veya üzeri
- **RAM**: 4GB (8GB önerilir)
- **Disk Alanı**: 500MB boş alan
- **SQL Server**: SQL Server 2016 veya üzeri (Express sürümü desteklenir)

### Ağ Gereksinimleri:
- SQL Server'a TCP/IP bağlantısı
- Port 1433 (varsayılan SQL Server portu) erişimi
- İnternet bağlantısı (ilk kurulum için)

## 🚀 Kurulum Adımları

### 1. Node.js Kurulumu

#### Windows:
1. [Node.js resmi sitesinden](https://nodejs.org/) LTS sürümünü indirin
2. İndirilen .msi dosyasını çalıştırın
3. Kurulum sihirbazını takip edin
4. Komut istemini açın ve doğrulayın:
   ```cmd
   node --version
   npm --version
   ```

#### macOS:
```bash
# Homebrew ile kurulum (önerilen)
brew install node

# Veya resmi siteden indirin
```

#### Linux (Ubuntu/Debian):
```bash
# NodeSource repository'sini ekleyin
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

# Node.js'i kurun
sudo apt-get install -y nodejs

# Doğrulayın
node --version
npm --version
```

### 2. Proje Dosyalarını İndirme

#### Seçenek A: ZIP Dosyası İndirme
1. Proje dosyalarını ZIP olarak indirin
2. Bir klasöre çıkarın (örn: `C:\PerformansAraci\`)

#### Seçenek B: Git ile Klonlama
```bash
git clone [PROJE_URL] performans-araci
cd performans-araci
```

### 3. Bağımlılıkları Yükleme

Proje klasörüne gidin ve bağımlılıkları yükleyin:

```bash
# Proje klasörüne gidin
cd performans-araci

# Bağımlılıkları yükleyin
npm install --legacy-peer-deps
```

**Not**: `--legacy-peer-deps` bayrağı React sürüm uyumsuzluğu nedeniyle gereklidir.

### 4. Uygulamayı Çalıştırma

#### Geliştirme Modu (Test için):
```bash
npm run dev
```

#### Üretim Modu:
```bash
# Uygulamayı derleyin
npm run build

# Üretim sunucusunu başlatın
npm start
```

Uygulama varsayılan olarak `http://localhost:3000` adresinde çalışacaktır.

## 🔧 Yapılandırma

### SQL Server Bağlantısı

Uygulama ilk çalıştırıldığında "Bağlantı" sekmesinden SQL Server bilgilerini girin:

- **Sunucu Adı**: `localhost\SQLEXPRESS` veya IP adresi
- **Veritabanı**: LOGO veritabanı adı (örn: `LOGO_FIRM001`)
- **Kullanıcı Adı**: SQL Server kullanıcı adı
- **Şifre**: Kullanıcı şifresi
- **Port**: 1433 (varsayılan)

### Güvenlik Ayarları

SQL Server'da TCP/IP protokolünü etkinleştirin:

1. **SQL Server Configuration Manager**'ı açın
2. **SQL Server Network Configuration** → **Protocols for [INSTANCE]**
3. **TCP/IP**'yi etkinleştirin
4. **SQL Server Services**'den SQL Server'ı yeniden başlatın

## 📦 Dağıtım Seçenekleri

### 1. Standalone Executable (Önerilen)

Tek dosya olarak dağıtım için:

```bash
# pkg paketini yükleyin
npm install -g pkg

# Executable oluşturun
pkg package.json --out-path dist/
```

### 2. Docker ile Dağıtım

```dockerfile
# Dockerfile oluşturun
FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

EXPOSE 3000
CMD ["npm", "start"]
```

```bash
# Docker image oluşturun
docker build -t performans-araci .

# Çalıştırın
docker run -p 3000:3000 performans-araci
```

### 3. Windows Service Olarak Kurulum

```bash
# pm2'yi global olarak yükleyin
npm install -g pm2
npm install -g pm2-windows-service

# Servisi kurun
pm2-service-install
pm2 start npm --name "PerformansAraci" -- start
pm2 save
```

## 🔍 Sorun Giderme

### Yaygın Sorunlar ve Çözümleri:

#### 1. "Cannot connect to SQL Server"
- SQL Server servisinin çalıştığını kontrol edin
- TCP/IP protokolünün etkin olduğunu doğrulayın
- Firewall ayarlarını kontrol edin
- Bağlantı bilgilerini doğrulayın

#### 2. "Port 3000 already in use"
```bash
# Farklı port kullanın
PORT=8000 npm run dev
```

#### 3. "Module not found" hataları
```bash
# Node modules'ı temizleyin ve yeniden yükleyin
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps
```

#### 4. "Permission denied" (Linux/macOS)
```bash
# npm'e sudo yetkisi verin veya nvm kullanın
sudo chown -R $(whoami) ~/.npm
```

### Log Dosyaları:
- Uygulama logları: `logs/app.log`
- Hata logları: `logs/error.log`
- SQL logları: `logs/sql.log`

## 📋 Sistem Gereksinimleri Kontrolü

Kurulum öncesi sistem kontrolü için:

```bash
# Node.js versiyonu
node --version  # v18.17.0+

# NPM versiyonu
npm --version   # 9.0.0+

# Bellek kontrolü
free -h         # Linux
wmic OS get TotalVisibleMemorySize /value  # Windows

# Disk alanı
df -h           # Linux/macOS
dir             # Windows
```

## 🔐 Güvenlik Önerileri

1. **Güçlü Şifreler**: SQL Server için güçlü şifreler kullanın
2. **Firewall**: Sadece gerekli portları açın
3. **SSL**: Mümkünse SSL bağlantısı kullanın
4. **Yedekleme**: Düzenli veritabanı yedeklemesi yapın
5. **Güncellemeler**: Uygulamayı düzenli olarak güncelleyin

## 📞 Destek

Sorun yaşadığınızda:

1. Bu rehberi kontrol edin
2. Log dosyalarını inceleyin
3. GitHub Issues'da arama yapın
4. Yeni issue oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında dağıtılmaktadır.

---

**Son Güncelleme**: 2024
**Versiyon**: 1.0.0
