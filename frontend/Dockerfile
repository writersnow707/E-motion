# 리엑트 빌드 -Student
FROM node:latest AS student-frontend
WORKDIR /app

COPY frontend/student/package.json ./
RUN yarn install

COPY frontend/student/ ./
RUN yarn build

# 리엑트 빌드 -Teacher
FROM node:latest AS teacher-frontend
WORKDIR /app

COPY frontend/teacher/package.json ./
RUN yarn install

COPY frontend/teacher/ ./
RUN yarn build

# Nginx 배포
FROM nginx:alpine

COPY --from=student-frontend /app/build /usr/share/nginx/html/student
COPY --from=teacher-frontend /app/build /usr/share/nginx/html/teacher

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443
