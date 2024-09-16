return {
    {
        "ptdewey/pendulum-nvim",
		opts = {
			log_file = vim.fn.expand("$HOME/Documents/.pendulum.csv"),
			timeout_len = 300,  -- 5 minutes
			timer_len = 60,     -- 1 minute
			gen_reports = true, -- Enable report generation (requires Go)
			top_n = 10,         -- Include top 10 entries in the report
		}
    },
}
