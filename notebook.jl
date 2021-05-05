using Markdown
using InteractiveUtils

using ExtremeStats, PyCall, Conda, DataFrames

Conda.pip_interop(true, "/Users/david/.julia/conda/3")

Conda.pip("install","numerapi")

Conda.pip("install","pandas")

begin
	numerapi = pyimport("numerapi")
	pandas = pyimport("pandas")
end

napi = numerapi.NumerAPI()

begin 
	raw_data = pandas.json_normalize(napi.daily_user_performances("david_plutus"), sep="-")
	raw_data.to_csv("data.csv")
end
