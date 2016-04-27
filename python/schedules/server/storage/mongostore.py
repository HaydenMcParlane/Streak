#################################################################
#	Data storage interface for underlying mongodb.
#	@author: Hayden McParlane
#	@creation-date: 2.23.2016
#################################################################
import copy
import datastore
from pymongo import MongoClient
from gi.overrides.Gdk import Cursor

class MongoInterface(datastore.DataStorageInterface):
    def __init__(self):
        datastore.DataStorageInterface.__init__(self)
        
    def __enter__(self):
        self.client = MongoClient()
        return self.client
    
    def __exit__(self, exc_type, exc_value, traceback):
        try:
            self.client.close()
        except Exception as e:
            print(e)
            raise Error()
    
    def find(self, **kwargs):
        result = list()
        with self as mongo:
            # TODO: Fix hardcode        
            cursor = mongo["streak"]["episodes"].find({})
            for document in cursor:                
                document['_id'] = str(document['_id'])                
                result.append(copy.deepcopy(document))
        return result
        
    def insert(self, database, collection, data, batch=False, **kwargs):
        with self as mongo:
            if many:
                # TODO: Implement
                raise NotImplementedError()
            else:
                coll = mongo[database][collection]
                result = coll.insert_one(data)
        return str(result)
        
    def update(self, data, **kwargs):
        raise NotImplementedError()
    
    def delete(self, data, **kwargs):
        raise NotImplementedError()