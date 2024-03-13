FROM python:3.10
WORKDIR /usr/src/app
COPY app.py /usr/src/app
RUN pip3 install flask
EXPOSE 80
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=80"]