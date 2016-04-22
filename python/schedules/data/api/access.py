###############################################################
#	Episodes and related data objects
#    @author: Hayden McParlane
#    @creation-date: 4.21.2016
#    @description:
#        API providing access to underlying data store. This API
#        abstracts the access from the structure of the underlying
#        store serving to decouple the two.       
###############################################################

# TODO: Find way to make data representation flexible (i.e, logical data
# structures that clients can use to access the data in a format that
# best suits client needs.

class DataAccess(object):
    def __init__(self):
        super(object, self).__init__()
        
    def read(self, **kwargs):
        raise NotImplementedError()
    
    def insert(self, **kwargs):
        raise NotImplementedError()
    
    def update(self, **kwargs):
        raise NotImplementedError()
    
    def delete(self, **kwargs):
        raise NotImplementedError()
    
    
################################################################
#    Episodes
################################################################
class Episodes(DataAccess):
    def __init__(self):
        super(DataAccess, self).__init__()
        
    def read(self, **kwargs):
        pass
    
    def insert(self, **kwargs):
        pass
    
    def update(self, **kwargs):
        pass
    
    def delete(self, **kwargs):
        pass