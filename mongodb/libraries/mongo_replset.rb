module MongoReplSet
  def self.initiate(mongo_node, port=27017)
    include Mongo
    begin
      mongo_client = MongoReplicaSetClient.new(["#{mongo_node}:#{port}"])
    rescue
      Chef::Log.debug('Seems like no ReplicaSet set up.')
      mongo_client = MongoClient.new(mongo_node, port)
      Chef::Log.debug("Primary #{mongo_client.primary}")
    end
  end
end
