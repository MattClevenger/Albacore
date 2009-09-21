require 'lib/msbuild'
require 'lib/spec/model/msbuildtestdata'
require 'lib/spec/model/msbuildfake'


describe MSBuild, "when an msbuild path is not specified" do
	
	before :all do
		@testdata= MSBuildTestData.new
		@msbuild = MSBuild.new
	end
	
	it "should default to the .net framework v3.5" do
		@msbuild.path_to_exe.should == @testdata.msbuild_path
	end
end

describe MSBuild, "when an msbuild path is specified" do
	
	before :all do
		@testdata= MSBuildTestData.new
		@msbuild = MSBuild.new "Some Path"
	end
	
	it "should use the specified path for the msbuild exe" do
		@msbuild.path_to_exe.should == "Some Path"
	end	
end

describe MSBuild, "when building a visual studio solution" do

	before :all do
		@testdata= MSBuildTestData.new
		@msbuild = MSBuild.new
		
		@msbuild.build @testdata.solution_path
	end
	
	it "should output the solution's binaries" do
		File.exist?(@testdata.output_path).should == true
	end
end

describe MSBuild, "when building a visual studio solution for a specified configuration" do
	
	before :all do
		@testdata= MSBuildTestData.new("Release")
		@msbuild = MSBuild.new
		
		@msbuild.properties = {:configuration => :release}
		@msbuild.build @testdata.solution_path
	end
	
	it "should output the solution's binaries according to the specified configuration" do
		File.exist?(@testdata.output_path).should == true
	end
end

describe MSBuild, "when specifying targets to build" do
	
	before :all do

		@testdata= MSBuildTestData.new
		@msbuild = MSBuild.new
		
		@msbuild.targets = [:Clean, :Build]
		@msbuild.build @testdata.solution_path
	end

	it "should build the targets" do
		$system_command.should include "/target:Clean;Build"
	end

end