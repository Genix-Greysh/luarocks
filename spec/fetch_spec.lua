local test_env = require("spec.util.test_env")

test_env.unload_luarocks()

describe("Luarocks fetch test #whitebox #w_fetch", function()
   local fetch
   local vers
   local fs
   
   setup(function()
      local cfg = require("luarocks.core.cfg")
      local fs_init = require("luarocks.fs_init")
      fs = fs_init.new(cfg.platforms, false, cfg.fs_use_modules)
      package.loaded["luarocks.fs"] = fs
      
      fetch = require("luarocks.fetch")
      vers = require("luarocks.vers")
   end)

   it("Fetch url to base dir", function()
      assert.are.same("v0.3", fetch.url_to_base_dir("https://github.com/hishamhm/lua-compat-5.2/archive/v0.3.zip"))
      assert.are.same("lua-compat-5.2", fetch.url_to_base_dir("https://github.com/hishamhm/lua-compat-5.2.zip"))
      assert.are.same("lua-compat-5.2", fetch.url_to_base_dir("https://github.com/hishamhm/lua-compat-5.2.tar.gz"))
      assert.are.same("lua-compat-5.2", fetch.url_to_base_dir("https://github.com/hishamhm/lua-compat-5.2.tar.bz2"))
      assert.are.same("parser.moon", fetch.url_to_base_dir("git://github.com/Cirru/parser.moon"))
      assert.are.same("v0.3", fetch.url_to_base_dir("https://github.com/hishamhm/lua-compat-5.2/archive/v0.3"))
   end)

   describe("fetch_sources", function()
      it("from Git", function()
         local rockspec = {
            format_is_at_least = vers.format_is_at_least,
            name = "testrock",
            version = "dev-1",
            source = {
               protocol = "git",
               url = "git://github.com/luarocks/testrock",
            },
            variables = {
               GIT = "git",
            },
         }
         local pathname, tmpdir = fetch.fetch_sources(rockspec, false)
         assert.are.same("testrock", pathname)
         assert.match("luarocks_testrock%-dev%-1%-", tmpdir)
         assert.match("^%d%d%d%d%d%d%d%d.%d%d%d%d%d%d.%x+$", rockspec.source.identifier)
      end)
   end)

end)
