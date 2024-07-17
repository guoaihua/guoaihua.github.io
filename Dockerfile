FROM node:18
COPY package*.json .
RUN npm install --regisry=https://registry.npm.taobao.org && npx hexo build
COPY . .
EXPOSE 4000
CMD ["node","index.js"]