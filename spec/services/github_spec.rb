require "spec_helper"

describe Github do
  context "when given a repo" do
    it "find pull requests", github_api: true do
      VCR.use_cassette("codemontage_oct_prs") do
        prs = Github.new.pull_requests_by_repo("CodeMontageHQ/codemontage",
                                               "codemontage",
                                               Time.new(2014, 10, 01),
                                               Time.new(2014, 10, 31))
        expect(prs.count).to eq(2)
      end
    end

    it "should find commits", github_api: true do
      VCR.use_cassette("codemontage_oct_commits") do
        commits = Github.new.commits_by_repo("CodeMontageHQ/codemontage",
                                             "codemontage",
                                             Time.new(2014, 10, 01),
                                             Time.new(2014, 10, 31))
        expect(commits.count).to eq(3)
      end
    end

    it "finds issues by repo", github_api: true do
      VCR.use_cassette("codemontage_oct_issues") do
        issues = Github.new.issues_by_repo("CodeMontageHQ/codemontage",
                                           "codemontage",
                                           Time.new(2014, 10, 01),
                                           Time.new(2014, 10, 31))
        expect(issues.count).to eq(3)
      end
    end

    it "finds forks by repo", github_api: true do
      VCR.use_cassette("codemontage_oct_forks") do
        forks = Github.new.forks_by_repo("codemontage",
                                         Time.new(2014, 10, 01),
                                         Time.new(2014, 10, 31))
        expect(forks.count).to eq(0)
      end
    end
  end

  context "when given a user", github_api: true do
    it "finds pull requests by user" do
      VCR.use_cassette("courte_jan_prs") do
        prs = Github.new.pull_requests_by_user("courte",
                                               Time.parse("2015-01-08"),
                                               Time.parse("2015-01-09"))
        expect(prs.count).to eq(7)
      end
    end

    it "finds commits by user", github_api: true do
      VCR.use_cassette("courte_jan_commits") do
        commits = Github.new.commits_by_user("courte",
                                             Time.parse("2015-01-07"),
                                             Time.parse("2015-01-08"))
        expect(commits.count).to eq(20)
      end
    end

    it "finds issues by user", github_api: true do
      VCR.use_cassette("courte_jan_issues") do
        issues = Github.new.issues_by_user("courte", Time.parse("2015-01-11"),
                                       Time.parse("2015-01-12"))
        expect(issues.count).to eq(2)
      end
    end

    it "finds forks by user", github_api: true do
      VCR.use_cassette("courte_oct_forks") do
        forks = Github.new.forks_by_user("courte", Time.parse("2014-10-01"),
                                     Time.parse("2014-10-31"))
        expect(forks.count).to eq(2)
      end
    end
  end

  it "returns the user login when given a uid", github_api: true do
    VCR.use_cassette("courte_user") do
      login = Github.new.get_user_login_by_uid("2766324")
      expect(login).to eq("courte")
    end
  end

  it "formats dates for octokit queries" do
    date1 = Time.new(2012, 12, 12, 13, 14, 15)
    date2 = Time.new(2011, 11, 11, 12, 13, 14)

    dates = Github.new.set_date_format(date1, date2)
    expect(dates).to eq(["2012-12-12", "2011-11-11"])
  end
end
