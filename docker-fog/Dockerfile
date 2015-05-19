FROM ruby:2.1

RUN gem install fog

RUN apt-get update -y
RUN apt-get install python-pip python-dev build-essential libffi-dev libssl-dev -y

RUN easy_install -U pip

RUN pip install python-novaclient
RUN pip install python-ceilometerclient
RUN pip install python-cinderclient
RUN pip install python-glanceclient
RUN pip install python-neutronclient
RUN pip install python-heatclient
RUN pip install python-saharaclient
RUN pip install python-swiftclient
RUN pip install python-troveclient
RUN pip install python-openstackclient
