FROM node:18
COPY package*.json .
COPY . .
RUN npm install --regisry=https://registry.npm.taobao.org && npx hexo generate
EXPOSE 4000
CMD ["node","index.js"]