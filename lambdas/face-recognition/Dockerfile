FROM public.ecr.aws/lambda/python:3.13

RUN dnf install -y \
    mesa-libGL \
    libSM \
    libXrender \
    libXext \
    libGLU \
    glibc \
    libgcc

COPY requirements.txt ./

RUN pip3 install -r ./requirements.txt

COPY handler.py ./

CMD [ "handler.lambda_handler" ]