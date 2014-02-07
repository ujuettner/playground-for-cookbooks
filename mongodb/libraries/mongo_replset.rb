module MongoReplSet
  def self.initiate(mongo_node, port, repl_set)
    include Mongo
    begin
      mongo_client = MongoReplicaSetClient.new(["#{mongo_node}:#{port}"])
      Chef::Log.debug('ReplicaSet already set up - nothing to do here.')
    rescue
      require 'json'
      Chef::Log.debug('Seems like no ReplicaSet set up - setting it up now.')
      mongo_client = MongoClient.new(mongo_node, port)
      rs_conf = {}
      rs_conf['_id'] = repl_set
      rs_conf['members'] = []
      rs_conf['members'][0] = {}
      rs_conf['members'][0]['_id'] = 0
      rs_conf['members'][0]['host'] = "#{mongo_node}:#{port}"
      mongo_client.db('admin').command({'replSetInitiate' => rs_conf.to_json})
    end
  end
end
