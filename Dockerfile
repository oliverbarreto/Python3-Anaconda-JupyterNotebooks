# Oliver Barreto Own container with Anaconda and Jupyter Notebooks alrady installed

FROM continuumio/anaconda3
MAINTAINER Oliver Barreto "oliver.barreto.online@gmail.com"
RUN /opt/conda/bin/conda install jupyter -y --quiet
RUN mkdir /tmp/notebooks
COPY ./jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
CMD /opt/conda/bin/jupyter notebook

