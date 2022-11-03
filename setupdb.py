import os
import yaml
"""
define the LOGGER settings
"""
import logging
import sys

BASE_DIR = "./"
LOG_FILE = BASE_DIR + "/" + "logs" + "/" + 'hdv.log'

LOGGER = logging.getLogger("redfish")
LOGGER.setLevel(logging.DEBUG)

FORMATTER = logging.Formatter('%(asctime)s - %(filename)s[line:%(lineno)d] \
    - %(funcName)s - %(levelname)s: %(message)s')

FILE = logging.FileHandler(filename=LOG_FILE, mode='w')
FILE.setLevel(logging.DEBUG)
FILE.setFormatter(FORMATTER)

CONSOLE = logging.StreamHandler()
CONSOLE.setLevel(logging.DEBUG)
CONSOLE.setFormatter(FORMATTER)

LOGGER.addHandler(CONSOLE)
LOGGER.addHandler(FILE)

# pylint: disable=E0611
def read_yaml(file):
    '''read a yaml file
    '''
    if not os.path.exists(file):
        LOGGER.info("%s not found", file)
        return None
    return yaml.load(open(file, "r"))


def write_yaml(file, dict_data):
    '''write a yaml file
    '''
    yaml.safe_dump(dict_data, open(file, "w"), explicit_start=True
