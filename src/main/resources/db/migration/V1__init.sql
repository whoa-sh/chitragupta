CREATE TABLE IF NOT EXISTS app_schema_marker (
	id BIGSERIAL PRIMARY KEY,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	note TEXT NOT NULL UNIQUE
);

INSERT INTO app_schema_marker (note)
VALUES ('baseline migration applied')
ON CONFLICT (note) DO NOTHING;
