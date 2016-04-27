#################################################################
#	Data storage interface specifying contract for data
#	storage access. Decouples storage access entities
#	from specific storage implementation.
#	@author: Hayden McParlane
#	@creation-date: 4.22.2016
#################################################################
class DataStorageInterface(object):
	'''Contract which must be adhered to by all concrete data storage
	implementations.'''
	def find(self, **kwargs):
		raise NotImplementedError()
	
	# TODO: LOW Do kwargs reduce performance in many way when
	# compared to a function without kwargs?
	def insert(self, database, collection, data, **kwargs):
		raise NotImplementedError()
	
	def update(self, database, collection, data, **kwargs):
		raise NotImplementedError()
	
	def delete(self, **kwargs):
		raise NotImplementedError()
	