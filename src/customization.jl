function get_config(config_loc="./tower.toml")
    config = TOML.parsefile(config_loc)
    config
end

