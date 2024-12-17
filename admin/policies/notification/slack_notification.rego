package spacelift

slack[{"channel_id": "C0000000000"}] {
  input.run_updated != null

  run := input.run_updated.run
  run.state == "FINISHED"
}

sample := true