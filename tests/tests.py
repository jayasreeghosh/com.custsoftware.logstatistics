'''
Created on 5 janv. 2015

@author: MRO
'''
import unittest
from cast.application.test import run




class Test(unittest.TestCase):


    def test_basic(self):

        run(kb_name='b800_8525_sql_local', application_name='transaction') 


if __name__ == "__main__":

    unittest.main()

#     import re
#     
#     re.compile("(?P<NEWLINE>\n)|(?P<SKIP>[ \t])|(?P<>(?<=(?:FROM|UPDATE|INTO)[ ]*S[0-9])[A-Z0-9]*(?= ))")
#     re.compile("(?P<NEWLINE>\n)|(?P<SKIP>[ \t])|(?P<>(?<=FROM|UPDATE|INTO[ ]S[0-9])[A-Z0-9]*(?= ))")
    
    