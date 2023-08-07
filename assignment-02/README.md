# Assignment-02
This directory contains the python code to get the properties of a compute instance/engine deployed on google cloud platform.

## Prerequisites
Below prerequisites must be fulfilled for the successful execution of code.

### Software Requirement
Code in this directory are meant for use with Python 3.x (check the version using `python3 --version`) and pip3 (check the version using `pip3 --version`). If you don't have the compatible version, download it from official python repository.

- [python3](https://www.python.org/downloads/) >= 3.11.1
- [pip3](https://pypi.org/project/pip/) >= 23.3.1
- [Cloud SDK](https://cloud.google.com/sdk/install) >= 414.0.0

### Bootstrap Virtual Environment
[venv](https://docs.python.org/3/library/venv.html) is a tool that creates isolated Python environments. These isolated environments can have separate versions of Python packages, which allows you to isolate one project's dependencies from the dependencies of other projects.

**Linux**
```
    cd assignment-02
    python3 -m venv env
    source env/bin/activate
    pip install -r requirements.txt
```

### Authentication and Authorization
The client library used in the python script supports authentication via Google Application Default Credentials, or by providing a JSON key file for a Service Account.

## Script Execution
This code supports authentication via Google Application Default Credentials, Hence make sure to authenticate yourself to google cloud via ADC with sufficient permissions.

- **Step-01:** Clone this repository: `git clone https://github.com/anupam-sy/assignment-solutions.git`
- **Step-02:** Setup the python virtual environment using [Bootstrap Virtual Environment](#bootstrap-virtual-environment).
- **Step-03:** Activate the python virtual environment and navigate to the directory `assignment-02` to install the requirements using: `pip install -r requirements.txt`  
- **Step-04:** Execute the python script: `python gce_properties.py`

## References
- https://cloud.google.com/python/docs/reference
- https://github.com/googleapis/google-cloud-python
