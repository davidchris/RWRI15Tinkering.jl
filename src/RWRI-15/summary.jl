### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 3fea381c-8b4f-11eb-0db0-9701a3447ddb
using Distributions, Plots, StatsPlots, Survival, Statistics, PlutoUI

# ╔═╡ f8988e20-8ce1-11eb-096d-45c3fb657e83
md" # RWRI#15 Technical Summary"

# ╔═╡ e026e85e-8ce2-11eb-24ef-4dd84cb657be
html"<button onclick='present()'>present</button>"

# ╔═╡ d4a856ea-8b55-11eb-1ab3-7347511e1d5b
import Pkg

# ╔═╡ d89bd6fa-8b55-11eb-000e-cd190c432d25
Pkg.add("PlutoUI")

# ╔═╡ 300d7882-8c17-11eb-27f2-8df170245c92
gr()

# ╔═╡ 38b63284-8b50-11eb-0100-3d640819af62
K = 1_000

# ╔═╡ 985a22de-8ce2-11eb-268d-e13e945f4aa6
md"## Central Limit"

# ╔═╡ 36030816-8b51-11eb-3bbe-99f9c372a692
plot(
	histogram(rand(Uniform(), K), label="single uniform"),
	histogram(( rand(Uniform(), K) + rand(Uniform(), K) ) / 2, label="2 avg uniform"),
	histogram(( rand(Uniform(), K) + rand(Uniform(), K) + rand(Uniform(), K) ) / 3, label="3 avg uniform"),
	histogram(( rand(Uniform(), K) + rand(Uniform(), K) + rand(Uniform(), K) + rand(Uniform(), K)  ) / 4, label="4 avg uniform"),
	layout=(2,2)
)
	

# ╔═╡ 7a718cd2-8b50-11eb-101b-8178142e592f
plot(
	plot(rand(Normal(), K), title="Behavioral Differences", ylims=(-100, 100), label="gaussian"),
	plot(rand(TDist(1.1), K), label="power law", ylims=(-100, 100)),
	layout=(2,1)
)


# ╔═╡ adbc0b80-8b50-11eb-023c-f3e60c2888cc
begin
	plot(
		histogram(rand(Normal(), K), title="Normal"), 
		histogram(rand(TDist(1.1), K), title="Power Law"), 
		layout = (2, 1), legend = false
	)
end

# ╔═╡ ee16db52-8b56-11eb-0d84-47c12457033d
begin
	pl = TDist(1.1); x_pl = rand(pl, K)
	normal = Normal(); x_normal = rand(normal, K)
	plot(
		plot(x_normal, ccdf(normal, x_normal),
			seriestype=:scatter, xlims=(0.1,100), xaxis=:log, yaxis=:log),
		plot(x_pl, ccdf(pl, x_pl), 
			seriestype=:scatter, xlims=(0.1,100), xaxis=:log, yaxis=:log),
		layout=(1,2)
	)
end

# ╔═╡ a46a5422-8ce2-11eb-2f13-db6dc08f691b
md"## Law of Large Numbers"

# ╔═╡ a958d146-8bf4-11eb-3fb5-59fdcaebd563
plot([cor(rand(Normal(), n), rand(Normal(), n)) for n=1:500],
	 ylims=(-1,1), seriestype=:line,
	 ylabel="correlation", xlabel="sample size"
)

# ╔═╡ 66638b3e-8be7-11eb-1f72-919dd4c2d00d
function corr(n)		
	return cor(rand(Normal(), n), rand(Normal(), n))
end

# ╔═╡ 7db4ec02-8bf2-11eb-302c-83a265e29552
@bind samplesize Slider(10:1000;show_value=true)

# ╔═╡ b3714786-8be7-11eb-3550-9968b2c626df
begin
	n = 1000;
	histogram(map(1:n) do i corr(samplesize) end, bins=25, xlims=(-0.75,0.75),
			  xlabel="correlation", ylabel="frequency", label="")
end

# ╔═╡ 26472e82-8bf5-11eb-1ae5-63a5546fbd5c
plot(
	plot([mean(rand(Normal(0,1), n)) for n=1:10^3], seriestype=:line, title="Law of Large Numbers, NOT! Mean",label="Normal", ylims=(-5,5), ylabel="mean"),
	plot([mean(rand(TDist(1.1), n)) for n=1:10^3], seriestype=:line, label="PowerLaw", ylims=(-50,50), xlabel="sample size", ylabel="mean"),
	layout=(2,1)
)
	

# ╔═╡ d95ac7ce-8bf6-11eb-019d-81056d6ba663
plot(
	plot([var(rand(Normal(0,1), n)) for n=1:10^3], seriestype=:line, title="Law of Large Numbers, NOT! Variance",label="Normal", yaxis=:log,
		 ylabel="log(variance)"),
	plot([var(rand(TDist(1.1), n)) for n=1:10^3], seriestype=:line, yaxis=:log, label="PowerLaw", xlabel="sample size", ylabel="log(variance)"),
	layout=(2,1)
)
	

# ╔═╡ Cell order:
# ╠═f8988e20-8ce1-11eb-096d-45c3fb657e83
# ╠═e026e85e-8ce2-11eb-24ef-4dd84cb657be
# ╠═d4a856ea-8b55-11eb-1ab3-7347511e1d5b
# ╠═d89bd6fa-8b55-11eb-000e-cd190c432d25
# ╠═3fea381c-8b4f-11eb-0db0-9701a3447ddb
# ╠═300d7882-8c17-11eb-27f2-8df170245c92
# ╠═38b63284-8b50-11eb-0100-3d640819af62
# ╟─985a22de-8ce2-11eb-268d-e13e945f4aa6
# ╠═36030816-8b51-11eb-3bbe-99f9c372a692
# ╠═7a718cd2-8b50-11eb-101b-8178142e592f
# ╠═adbc0b80-8b50-11eb-023c-f3e60c2888cc
# ╠═ee16db52-8b56-11eb-0d84-47c12457033d
# ╟─a46a5422-8ce2-11eb-2f13-db6dc08f691b
# ╠═a958d146-8bf4-11eb-3fb5-59fdcaebd563
# ╠═66638b3e-8be7-11eb-1f72-919dd4c2d00d
# ╠═7db4ec02-8bf2-11eb-302c-83a265e29552
# ╠═b3714786-8be7-11eb-3550-9968b2c626df
# ╠═26472e82-8bf5-11eb-1ae5-63a5546fbd5c
# ╠═d95ac7ce-8bf6-11eb-019d-81056d6ba663
