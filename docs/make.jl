using Documenter, Connectomes

makedocs(
	sitename="Connectomes.jl",
	modules = [Connectomes],
	format=Documenter.HTML(prettyurls=false, size_threshold=1000000),
	pages = [
	"Home" => "index.md",
	"Connectomes" => "connectomes.md"]
)

deploydocs(;
    repo = "github.com/PavanChaggar/Connectomes.jl.git",
	devbranch="main",
)