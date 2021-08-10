### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ ee33bee5-e946-4ca4-b57f-fb4bce9a42a8
using Distributions, Plots, StatsPlots, Statistics

# ╔═╡ 3f43596e-f884-11eb-1c4e-4542bef7267c
md"# Examples from 'Statistical Consquences of Fat Tails' by Nassim Nicholas Taleb - Chapter 4"

# ╔═╡ c7858550-43d8-4840-bf8a-c936f01a5968
md"Chapter 4: 'Univariate Fat Tails, Level 1, Finite Moments'"

# ╔═╡ 60e1eea1-e54a-4a29-ad1c-ca7145a7f197
md"[...] Fatten tails by 'stochastizing' either standard deviation or variance [...]"

# ╔═╡ eae7a5b9-9303-415a-8a54-c4d7f5f7428b
gr()

# ╔═╡ 4e6dc44f-405c-4eac-a94d-3c261d6a64c2
function avg_dist(σ, a, n)
	return mean.(
			rand(Normal(0, σ*sqrt(1+a)), n) + rand(Normal(0, σ*sqrt(1-a)), n)
		)
end

# ╔═╡ 716d43d1-8459-4bd3-a738-a88c8ae63659
function dist_avg_param(σ, a, n)
	mean_σ = σ*sqrt(1+a) + σ*sqrt(1-a)
	return rand(Normal(0, mean_σ), n)
end

# ╔═╡ cac0d5b6-d0a6-4e43-a551-74b2db0ae29d
begin
	n = 10^5;
	index = 1:n;
	data = [avg_dist(1, 0.1, n) dist_avg_param(1, 0.1, n)];
end

# ╔═╡ 870120cc-5a7c-4ee6-9fc4-c97975b51cca
histogram(index, data, alpha=.5, labels=["Average of Distributions" "Distribution of Averages"], bins=200)

# ╔═╡ 599fecc5-60ce-41a5-abaa-5c9e9c61ced9
md"
Taking the average of two Normal distributions with different--\"opposing\"--standard deviations is more thin tailed than the Normal distributions with averaged standard deviation parameters.
"

# ╔═╡ c9ffd397-cbcd-44eb-9afb-627b31ed72e6
histogram(data[:,2] - data[:,1])

# ╔═╡ 16fcf068-7715-4559-8fdc-9689eaea2a71
md"
> [...] the [above] difference is owned to Jensen's inequality[...]
(p. 67, ch. 4.1)
"

# ╔═╡ Cell order:
# ╟─3f43596e-f884-11eb-1c4e-4542bef7267c
# ╟─c7858550-43d8-4840-bf8a-c936f01a5968
# ╟─60e1eea1-e54a-4a29-ad1c-ca7145a7f197
# ╠═ee33bee5-e946-4ca4-b57f-fb4bce9a42a8
# ╠═eae7a5b9-9303-415a-8a54-c4d7f5f7428b
# ╠═4e6dc44f-405c-4eac-a94d-3c261d6a64c2
# ╠═716d43d1-8459-4bd3-a738-a88c8ae63659
# ╠═cac0d5b6-d0a6-4e43-a551-74b2db0ae29d
# ╠═870120cc-5a7c-4ee6-9fc4-c97975b51cca
# ╟─599fecc5-60ce-41a5-abaa-5c9e9c61ced9
# ╠═c9ffd397-cbcd-44eb-9afb-627b31ed72e6
# ╟─16fcf068-7715-4559-8fdc-9689eaea2a71
