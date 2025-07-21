#!/bin/bash

# Renkli çıktı için
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}   PERFORMANS OPTIMIZASYON ARACI - KURULUM${NC}"
echo -e "${BLUE}   LOGO Yazılım SQL Server Performans Aracı${NC}"
echo -e "${BLUE}================================================${NC}"
echo

# Node.js kontrolü
echo -e "${YELLOW}[1/5] Node.js kontrol ediliyor...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}HATA: Node.js bulunamadı!${NC}"
    echo -e "${RED}Lütfen Node.js'i yükleyin: https://nodejs.org/${NC}"
    echo
    echo "Ubuntu/Debian için:"
    echo "  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -"
    echo "  sudo apt-get install -y nodejs"
    echo
    echo "macOS için:"
    echo "  brew install node"
    exit 1
fi

NODE_VERSION=$(node --version)
echo -e "${GREEN}Node.js bulundu: $NODE_VERSION${NC}"

# NPM kontrolü
echo
echo -e "${YELLOW}[2/5] NPM kontrol ediliyor...${NC}"
if ! command -v npm &> /dev/null; then
    echo -e "${RED}HATA: NPM bulunamadı!${NC}"
    exit 1
fi

NPM_VERSION=$(npm --version)
echo -e "${GREEN}NPM bulundu: $NPM_VERSION${NC}"

# Minimum versiyon kontrolü
NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
if [ "$NODE_MAJOR" -lt 18 ]; then
    echo -e "${RED}UYARI: Node.js v18 veya üzeri önerilir. Mevcut: $NODE_VERSION${NC}"
fi

# Bağımlılıkları yükleme
echo
echo -e "${YELLOW}[3/5] Bağımlılıklar yükleniyor...${NC}"
echo -e "${YELLOW}Bu işlem birkaç dakika sürebilir...${NC}"

if ! npm install --legacy-peer-deps; then
    echo -e "${RED}HATA: Bağımlılıklar yüklenemedi!${NC}"
    echo -e "${RED}Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.${NC}"
    exit 1
fi

echo -e "${GREEN}Bağımlılıklar başarıyla yüklendi!${NC}"

# Uygulamayı derleme
echo
echo -e "${YELLOW}[4/5] Uygulama derleniyor...${NC}"

if ! npm run build; then
    echo -e "${RED}HATA: Uygulama derlenemedi!${NC}"
    echo -e "${RED}Lütfen hata mesajlarını kontrol edin.${NC}"
    exit 1
fi

echo -e "${GREEN}Uygulama başarıyla derlendi!${NC}"

# Kurulum tamamlandı
echo
echo -e "${YELLOW}[5/5] Kurulum tamamlandı!${NC}"
echo
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}   KURULUM BAŞARILI!${NC}"
echo -e "${GREEN}================================================${NC}"
echo
echo -e "${BLUE}Uygulamayı başlatmak için:${NC}"
echo -e "  ${YELLOW}npm run dev${NC}        (Geliştirme modu)"
echo -e "  ${YELLOW}npm run production${NC} (Üretim modu)"
echo
echo -e "${BLUE}Uygulama adresi: ${YELLOW}http://localhost:8000${NC}"
echo

# Kullanıcıya seçenek sun
echo -e "${BLUE}Uygulamayı şimdi başlatmak istiyor musunuz? (y/n):${NC}"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Uygulama başlatılıyor...${NC}"
    echo -e "${BLUE}Tarayıcınızda http://localhost:8000 adresini açın${NC}"
    echo -e "${BLUE}Durdurmak için Ctrl+C tuşlarına basın${NC}"
    echo
    
    # macOS'ta tarayıcıyı aç
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sleep 2 && open http://localhost:8000 &
    fi
    
    # Linux'ta tarayıcıyı aç (xdg-open varsa)
    if command -v xdg-open &> /dev/null; then
        sleep 2 && xdg-open http://localhost:8000 &
    fi
    
    npm run dev
else
    echo -e "${GREEN}Kurulum tamamlandı. İyi kullanımlar!${NC}"
fi
