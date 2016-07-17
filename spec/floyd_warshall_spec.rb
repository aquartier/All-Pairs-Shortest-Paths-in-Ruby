require 'rspec'
require 'floyd_warshall'


describe "Floyd Warshall" do
  let(:v0){ Vertex.new(0) }
  let(:v1){ Vertex.new(1) }
  let(:v2){ Vertex.new(2) }
  let(:v3){ Vertex.new(3) }
  let(:e1){ Edge.new(v0, v3, 10)}
  let(:e2){ Edge.new(v0, v1, 5) }
  let(:e3){ Edge.new(v1, v2, 3) }
  let(:e4){ Edge.new(v2, v0, -4) }
  let(:e5){ Edge.new(v2, v3, -1) }
  let(:graph){ Graph.new([v0, v1, v2, v3], [e1, e2, e3, e4, e5])}
  context "#generate_shortest_path_skeleton" do
    it "generates a skeleton correctly" do
      result = graph.generate_shortest_path_skeleton
      expect(result[v0]).to eq({
        v0 => 0,
        v1 => 5,
        v2 => Float::INFINITY,
        v3 => 10
        })
      expect(result[v1]).to eq({
        v0 => Float::INFINITY,
        v1 => 0,
        v2 => 3,
        v3 => Float::INFINITY
        })
    end
  end

  context "#all_pairs_shortest_paths" do
    it "returns all pairs shortest paths" do
      result = graph.all_pairs_shortest_paths
      expect(result[v0]).to eq({
        v0 => 0,
        v1 => 5,
        v2 => 8,
        v3 => 7
        })
       expect(result[v2]).to eq({
        v0 => -4,
        v1 => 1,
        v2 => 0,
        v3 => -1
        })

      expect(result[v3]).to eq({
        v0 => Float::INFINITY,
        v1 => Float::INFINITY,
        v2 => Float::INFINITY,
        v3 => 0
        })
    end
  end

end