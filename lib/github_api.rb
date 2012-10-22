require 'octokit'

class GithubApi
  class << self
    def repository(username, repository)
      github_client.repo(:username => username, :repo => repository)
    end

    def repository_exists?(username, repository)
      begin
        repository(username, repository)
        return true
      rescue Octokit::NotFound
        return false
      end
    end

    def repository_commiters_details(username, repository)
      commiters = github_client.contributors(:username => username, :repo => repository)
      commiters.map {|user| self.user(user.login) }
    end

    def user(username)
      github_client.user(username)
    end

    def github_client
      if Settings.github && Settings.github.login
        Octokit::Client.new(:login => Settings.github.login, :password => Settings.github.password)
      elsif Settings.github && Settings.github.client_id
        Octokit::Client.new(:client_id => Settings.github.client_id, :client_secret => Settings.github.client_secret)
      else
        Octokit
      end
    end
  end
end
