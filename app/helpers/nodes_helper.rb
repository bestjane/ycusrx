module NodesHelper
  def render_node_topics_count(node)
    node.topics.count
  end
  
  def render_node_name(name, id)
    link_to(name, node_topics_path(id), :class => 'node')
  end
end
