### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ e2d165ea-8efe-11eb-0505-65311ef915fa
using Pkg

# ╔═╡ c41ad652-8efe-11eb-2bec-45044027da71
using CSV, DataFrames, Plots, StatsPlots, EmpiricalCDFs, StatsBase, ShiftedArrays, Statistics, Distributions, Dates

# ╔═╡ 70a19b4e-8f05-11eb-224b-5df1b5308b30
Pkg.add("ShiftedArrays")

# ╔═╡ 84c098cc-8f06-11eb-29b3-e11faff4f67e
pyplot()

# ╔═╡ 1b2f8ff0-8eff-11eb-181e-3542d87b88fd
btcdata = DataFrame(
	CSV.File("BTC-USD.csv", 
		# types=Dict("Open" => Float16,
		# 	 "High" => Float16,
		# 	 "Low" => Float16,
		# 	 "Close" => Float16,
		# 	 "Adj Close" => Float16,
		# 	 "Volume" => Int)
	)
)

# ╔═╡ cd0240d6-8f10-11eb-30c0-f72bc355d709
describe(btcdata)

# ╔═╡ e6ea09ea-8eff-11eb-2e0c-7d3e532fef5b
@df btcdata plot(:Date, :Close)

# ╔═╡ 67ad1e5e-8f01-11eb-239a-877da6996b3a
@df btcdata plot(:Date, :Close, yaxis=:log)

# ╔═╡ 841df9f2-8f01-11eb-10af-fde225b0ed04
@df btcdata histogram(:Close)

# ╔═╡ 0818e5bc-8f07-11eb-3b0f-4712461dfc62
returns = [btcdata[i, :Close] - btcdata[i-1,:Close] for i=2:length(btcdata[:Close]) ]

# ╔═╡ 21c6e3fc-8f06-11eb-3e81-652aad55e40e
logreturns = [ log(btcdata[i, :Close] / btcdata[i-1,:Close]) for i=2:length(btcdata[:Close]) ]

# ╔═╡ 1293b38c-8f07-11eb-3fac-814f22d8ecd8
plot(
	histogram(returns),
	histogram(rand(Normal(mean(returns), std(returns)), length(returns)), xlims=(minimum(returns),maximum(returns))),
	layout=(2,1)
)
	

# ╔═╡ fbad7c0c-8f10-11eb-2eac-f3588fdce9fb
histogram([returns, rand(Normal(mean(returns), std(returns)), length(returns))], bins=-10^4:200:10^4)
	

# ╔═╡ 37abb3d4-8f06-11eb-1f55-098daa698f59
histogram(logreturns)

# ╔═╡ 75b8244c-8f08-11eb-2413-f9e77b9c0cec
function empiricalcdf(v)
	empcdf = EmpiricalCDF()
	append!(empcdf, v)
	sort!(empcdf)
	return empcdf
end

# ╔═╡ b5023930-8f03-11eb-3e0d-c598e1526937
begin
	lr_close_empcdf = empiricalcdf(logreturns)
	r_close_empcdf = empiricalcdf(returns)
	close_empcdf = empiricalcdf(btcdata[:Close])
end

# ╔═╡ 2c76370e-8f07-11eb-1b20-41861bebfe81
plot(
	plot(returns, r_close_empcdf(returns), seriestype=:scatter, label="returns"),
	plot(logreturns, lr_close_empcdf(logreturns), seriestype=:scatter, label="logreturns"),
	plot(btcdata[:Close], close_empcdf(btcdata[:Close]), seriestype=:scatter, label="close"),
	layout=(1,3)
)

# ╔═╡ 39c023b6-8f07-11eb-3b5c-7341e02b7e90
plot(
	returns, 
	r_close_empcdf(returns), 
	seriestype=:scatter,
	yaxis=:log,
	xaxis=:log,
	xlims=(1,10^5)
)

# ╔═╡ 11458512-8f04-11eb-08c4-733a2ae79b86
plot(
	logreturns, 
	lr_close_empcdf(logreturns), 
	seriestype=:scatter,
	yaxis=:log,
	xaxis=:log,
	xlims=(0.01,0.5)
)

# ╔═╡ Cell order:
# ╠═e2d165ea-8efe-11eb-0505-65311ef915fa
# ╠═70a19b4e-8f05-11eb-224b-5df1b5308b30
# ╠═c41ad652-8efe-11eb-2bec-45044027da71
# ╠═84c098cc-8f06-11eb-29b3-e11faff4f67e
# ╠═1b2f8ff0-8eff-11eb-181e-3542d87b88fd
# ╠═cd0240d6-8f10-11eb-30c0-f72bc355d709
# ╠═e6ea09ea-8eff-11eb-2e0c-7d3e532fef5b
# ╠═67ad1e5e-8f01-11eb-239a-877da6996b3a
# ╠═841df9f2-8f01-11eb-10af-fde225b0ed04
# ╠═0818e5bc-8f07-11eb-3b0f-4712461dfc62
# ╠═21c6e3fc-8f06-11eb-3e81-652aad55e40e
# ╠═1293b38c-8f07-11eb-3fac-814f22d8ecd8
# ╠═fbad7c0c-8f10-11eb-2eac-f3588fdce9fb
# ╠═37abb3d4-8f06-11eb-1f55-098daa698f59
# ╠═75b8244c-8f08-11eb-2413-f9e77b9c0cec
# ╠═b5023930-8f03-11eb-3e0d-c598e1526937
# ╠═2c76370e-8f07-11eb-1b20-41861bebfe81
# ╠═39c023b6-8f07-11eb-3b5c-7341e02b7e90
# ╠═11458512-8f04-11eb-08c4-733a2ae79b86
