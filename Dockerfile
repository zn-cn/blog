FROM node:8.11.2

LABEL maintainer="yun_tofar@qq.com"
LABEL version="1.0"
LABEL description="blog"

WORKDIR /app/src

COPY . .
RUN npm install -g hexo-cli --registry https://registry.npm.taobao.org
RUN npm install --registry https://registry.npm.taobao.org

EXPOSE 4000
CMD ["hexo", "server"]