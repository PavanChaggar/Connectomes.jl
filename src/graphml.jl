function get_node_attributes(graph)
    n_nodes = length(graph["node"])
    coords = Array{Float64}(undef, n_nodes, 3)
    nID = Vector{Int}(undef, n_nodes)
    region = Vector{String}(undef, n_nodes)
    labels = Vector{String}(undef, n_nodes)
    lobe = Vector{String}(undef, n_nodes)
    hemisphere = Vector{String}(undef, n_nodes)
    for i ∈ 1:n_nodes
        for j ∈ child_elements(graph["node"][i])
            if attribute(j, "key") == "d1"
                coords[i, 1] = parse(Float64, LightXML.content(j))
            elseif attribute(j, "key") == "d2"
                coords[i, 2] = parse(Float64, LightXML.content(j))
            elseif attribute(j, "key") == "d3"
                coords[i, 3] = parse(Float64, LightXML.content(j))
            elseif attribute(j, "key") == "d4"
                nID[i] = parse(Int, LightXML.content(j))
            elseif attribute(j, "key") == "d5"
                region[i] = LightXML.content(j)
            elseif attribute(j, "key") == "d6"
                labels[i] = LightXML.content(j)
            elseif attribute(j, "key") == "d7"
                lobe[i] = LightXML.content(j)
            elseif attribute(j, "key") == "d8"
                hemisphere[i] = LightXML.content(j)
            end
        end
    end
    x, y, z = coords[:,1], coords[:,2], coords[:,3]
    return nID, labels, region, lobe, hemisphere, x, y, z

end

function get_adjacency_matrix(graph, N)
    L = zeros(N,N)
    N = zeros(N,N)

    local n
    local l
    for edge in graph["edge"]
        i = parse(Int, attribute(edge, "source"))
        j = parse(Int, attribute(edge, "target"))
        for child in child_elements(edge)
            if attribute(child, "key") == "d9"
                n = parse(Float64, LightXML.content(child))
            elseif attribute(child, "key") == "d10"
               l = parse(Float64, LightXML.content(child))
            end
        end
        N[i,j] = n
        L[i,j] = l
    end
    return symmetrise(N), symmetrise(L)
end


function load_graphml(graph_path::String)
    xdoc = parse_file(graph_path)
    xroot = root(xdoc)
    ces = collect(child_elements(xroot))

    parc = Parcellation(get_node_attributes(ces[end])...)

    N, L = get_adjacency_matrix(ces[end], length(parc))
    return parc, N, L
end

function load_parcellation(graph_path::String)
    xdoc = parse_file(graph_path)
    xroot = root(xdoc)
    ces = collect(child_elements(xroot))
    
    get_node_attributes(ces[end])
end

for_dict = Dict(1 => "node", 
                2 => "node",
                3 => "node", 
                4 => "node", 
                5 => "node",
                6 => "node",
                7 => "node",
                8 => "node",
                9 => "edge",
                10 => "edge", 
)
type_dict = Dict(1=> "double", 
                 2 => "double",
                 3 => "double", 
                 4 => "string", 
                 5 => "string",
                 6 => "string",
                 7 => "string",
                 8 => "string",
                 9 => "int",
                 10 => "double", 
)
name_dict = Dict(1 => "dn_position_x", 
                 2 => "dn_position_y",
                 3 => "dn_position_z", 
                 4 => "dn_correspondence_id", 
                 5 => "dn_region",
                 6 => "fn_fsname",
                 7 => "dn_lobe",
                 8 => "dn_hemisphere",
                 9 => "number_of_fibers",
                 10 => "fiber_length",
)
field_dict = Dict(1 => :x,
               2 => :y,
               3 => :z,
               4 => :ID,
               5 => :Cortex,
               6 => :Label,
               7 => :Lobe,
               8 => :Hemisphere)

function add_keys!(root)
    for i in 1:10
        c = new_child(root, "key")
        set_attribute(c, "attr.name", name_dict[i])
        set_attribute(c, "attr.type", type_dict[i])
        set_attribute(c, "for", for_dict[i])
        set_attribute(c, "id", "d$i")
    end
end

function make_xml()
    xdoc = XMLDocument()
    root = create_root(xdoc, "graphml")
    add_keys!(root)

    xdoc
end

function add_nodes!(connectome::Connectome, c)
    for j in 1:length(connectome.parc)
        g = new_child(c, "node")
        set_attribute(g, "id", "$j")

        for i in 1:8
            d = new_child(g, "data")
            set_attribute(d, "key", "d$(i)")
            add_text(d, "$(getfield(connectome.parc[j], field_dict[i]))")
        end
    end
end

function add_edges!(connectome::Connectome, c)
    n_edges = findall( x -> x > 0, connectome.n_matrix)
    
    for edge in n_edges
        s, t = edge.I
        g = new_child(c, "edge")
        set_attribute(g, "source", "$s")
        set_attribute(g, "target", "$t")
        
        d = new_child(g, "data")
        set_attribute(d, "key", "d9")
        add_text(d, "$(connectome.n_matrix[edge])")
        
        d = new_child(g, "data")
        set_attribute(d, "key", "d10")
        add_text(d, "$(connectome.l_matrix[edge])")
    
    end

end

function save_connectome(filename::String, connectome::Connectome)
    xdoc = make_xml()

    r = root(xdoc)
    c = new_child(r, "graph")
    add_nodes!(connectome, c)
    add_edges!(connectome, c)
    save_file(xdoc, filename)
end