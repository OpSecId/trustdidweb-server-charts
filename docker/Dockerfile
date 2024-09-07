FROM python:3.12

RUN git clone https://github.com/OpSecId/trustdidweb-server-py.git

WORKDIR /trustdidweb-server-py/server

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

CMD [ "python", "main.py" ]