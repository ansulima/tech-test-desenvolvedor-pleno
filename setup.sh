echo "🚀 Email Processor - Setup Script"
echo "=================================="
echo ""

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not available. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

echo "📦 Building Docker containers..."
docker compose build

if [ $? -ne 0 ]; then
    echo "❌ Failed to build containers"
    exit 1
fi

echo "✅ Containers built successfully"
echo ""

echo "🚀 Starting services..."
docker compose up -d

if [ $? -ne 0 ]; then
    echo "❌ Failed to start services"
    exit 1
fi

echo "✅ Services started successfully"
echo ""

echo "⏳ Waiting for database to be ready..."
sleep 5

echo "🗄️  Setting up database..."
docker compose run --rm web bundle exec rails db:create db:migrate

if [ $? -ne 0 ]; then
    echo "❌ Failed to setup database"
    exit 1
fi

echo "✅ Database setup completed"
echo ""

echo "🌱 Seeding database with example emails..."
docker compose run --rm web bundle exec rails db:seed

echo ""
echo "=================================="
echo "✅ Setup completed successfully!"
echo ""
echo "📝 Access the application at: http://localhost:3000"
echo "📊 Access Sidekiq dashboard at: http://localhost:3000/sidekiq"
echo ""
echo "Useful commands:"
echo "  - View logs: docker compose logs -f"
echo "  - Stop services: docker compose down"
echo "  - Run tests: docker compose run --rm web bundle exec rspec"
echo "  - Rails console: docker compose run --rm web bundle exec rails console"
echo ""
