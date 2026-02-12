import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const SUPABASE_URL = 'https://rnlzbfadlujocggawxvl.supabase.co'
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJubHpiZmFkbHVqb2NnZ2F3eHZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA5MjgwMTAsImV4cCI6MjA4NjUwNDAxMH0.1ZxwST9yFSpDiPR7Iyd6WfRnozOzI9Ftms7dXiHRocE'

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)
