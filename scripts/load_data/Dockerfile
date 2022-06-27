FROM amazon/aws-lambda-python:3.8

COPY ./load_data ./
COPY ./classes ./classes
RUN pip3 install -r requirements.txt
RUN chmod 644 $(find . -type f)
RUN chmod 755 $(find . -type d)
CMD ["app.lambda_handler"]