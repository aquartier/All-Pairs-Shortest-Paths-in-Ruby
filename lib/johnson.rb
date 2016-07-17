require_relative "./vertex.rb"
require_relative "./edge.rb"
class Graph
  attr_reader :vertices, :edges

  def initialize(vertices, edges)
    @vertices = vertices
    @edges = edges
  end

  def johnson_shortest_paths
    msp = create_modified_graph

    edges.each do |edge|
      src, dest, weight = edge.src, edge.dest, edge.cost
      edge.cost = weight + msp[src] - msp[dest]
    end

    self.class.dijkstra(vertices, edges, msp)
  end

  def create_modified_graph
    mod_edges, mod_vertices = edges.dup, vertices.dup
    virtual_vertex = Vertex.new(99)

    vertices.each do |vertex|
      new_edge = Edge.new(virtual_vertex, vertex, 0)
      mod_edges << new_edge
    end
    mod_vertices << virtual_vertex
    
    self.class.bellman_ford(mod_vertices, mod_edges)
  end

  def self.bellman_ford(vertices, edges)
    shortest_paths = Hash.new(Float::INFINITY)
    shortest_paths[vertices.last] = 0

    vertices.length.times do |i|
      edges.each do |edge|
        src, dest, cost = edge.src, edge.dest, edge.cost
        if shortest_paths[src] != Float::INFINITY && 
            shortest_paths[src] + cost < shortest_paths[dest]  
          shortest_paths[dest] = shortest_paths[src] + cost
        end
      end
    end

    shortest_paths
  end

  def self.dijkstra(vertices, edges, old_sps)
    shortest_paths = []

    vertices.each do |vertex|
      shortest_path = {}
      frontier = Hash.new do |h, v| 
        h[v] = {
        cost: Float::INFINITY,
        actual_cost: 0
       }
      end
      frontier[vertex][:cost] = 0
      frontier[vertex][:actual_cost] = 0

      until frontier.empty?
        cur_vertex, cost_hash = frontier.min_by { |h, v| v[:cost] }
        src_cost, src_actual_cost = cost_hash[:cost], cost_hash[:actual_cost]

        shortest_path[cur_vertex] = src_actual_cost
        frontier.delete(cur_vertex)

        cur_vertex.to_edges.each do |edge|
          src, dest, dest_cost = edge.src, edge.dest, edge.cost
          next if shortest_path[dest]

          if src_cost + dest_cost < frontier[dest][:cost]
            actual_cost = dest_cost - old_sps[src] + old_sps[dest]

            frontier[dest][:cost] = src_cost + dest_cost
            frontier[dest][:actual_cost] = src_actual_cost + actual_cost
          end
        end
      end

      shortest_paths << shortest_path
    end

    shortest_paths
  end
end