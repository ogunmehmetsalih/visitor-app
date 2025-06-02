# Temel image
FROM node:18

# Çalışma dizinini ayarla
WORKDIR /app

# package.json ve package-lock.json kopyala
COPY package*.json ./

# Bağımlılıkları yükle
RUN npm install

# Uygulama dosyalarını kopyala
COPY app/ .

# Uygulama 3000 portunu kullanacak
EXPOSE 3000

# Uygulamayı başlat
CMD ["npm", "start"]

