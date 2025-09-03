# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy everything and restore dependencies
COPY *.csproj .
RUN dotnet restore

# Copy the rest of the code and publish
COPY . .
RUN dotnet publish -c Release -o out

# Use the official ASP.NET runtime image for running
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .

# Expose port (Render uses PORT env variable)
ENV ASPNETCORE_URLS=http://+:$PORT
EXPOSE $PORT

# Start the app
ENTRYPOINT ["dotnet", "SpeechApp2.0.dll"]
