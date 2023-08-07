# Import the required python packages/libraries
import argparse

def dict_parser(dict_object, given_key):
    """
    Function to parse the nested dictionary.
    """
    
    def get_value(value):
        for key, value in value.items():
            if(type(value) is dict):
                get_value(value)
            else:
                print(value)

    def get_data(dict_object):
        for key, value in dict_object.items():
            if(key == given_key):
                if(type(value) is dict):
                    get_value(value)
                else:
                    print(value)
            else:
                get_data(value)

    get_data(dict_object)
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("key", help="Please enter the key to get the value")
    args = parser.parse_args()

    dict_object = {"x":{"y":{"z":"a"}}}
    dict_parser(dict_object, args.key)
