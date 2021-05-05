using Extremes, Dates, DataFrames, Distributions, Plots, StatsBase, EmpiricalCDFs, CSV
pyplot()

d1 = Pareto(1, 1)
d2 = Normal(5, 1)

df = DataFrame(CSV.File("data.csv"))
sort!(df, [:date])
dropmissing!(df, :stakeValue)
filter!(row -> !(row.stakeValue == 0.0),  df)
# filter!(:stakeValue => x -> !any(f -> f(x), (ismissing, isnothing, isnan)), df)

plot(df[:stakeValue])

sv = df[:stakeValue]

empcdf = EmpiricalCDF()
append!(empcdf, sv)
sort!(empcdf)

mean(empcdf) / mad(empcdf)

empcdf(sv)
data(empcdf)

xs = rand(d1, 10_000)
dccdf = ccdf(d1, xs)

plot(xs)

plot(xs, dccdf, seriestype=:scatter, xaxis=:log, yaxis=:log)
# xlabel!("ccdf(pareto, xs)")
# ylabel!("xs")

plot(sv, empcdf(sv), seriestype=:scatter, xaxis=:log, yaxis=:log)