FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["2023-0727-124617-25543-noname.csproj", "./"]
RUN dotnet restore "2023-0727-124617-25543-noname.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "2023-0727-124617-25543-noname.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "2023-0727-124617-25543-noname.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "2023-0727-124617-25543-noname.dll"]
