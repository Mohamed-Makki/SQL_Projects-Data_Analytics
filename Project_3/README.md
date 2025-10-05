

## 🎵 Spotify Music Data Analysis – SQL Project

<p align="center">
  <img src="https://github.com/user-attachments/assets/aa562904-be35-4fa4-a9e1-4676f7c96bf1" alt="Spotify Logo" width="800"/>
</p>


### 📌 Overview

This project aims to explore and analyze a dataset containing information about music tracks on Spotify and YouTube using **SQL queries**. The dataset includes track metadata such as artist, album, streams, energy, danceability, likes, comments, video information, and more.

The analysis is divided into **three levels of difficulty**:
 **Easy**, **Medium**, and **Advanced**, progressively introducing more complex SQL features including aggregation, filtering, subqueries, and window functions.

------

### ✅ Dataset Assumptions

The dataset contains at least the following key columns:

- `track`, `artist`, `album`, `album_type`
- `stream`, `views`, `likes`, `comments`
- `energy`, `danceability`, `liveness`, `energy_liveness`
- `licensed`, `official_video`, `most_played_on`

------

## 🔹 Easy Level Analysis

1. **Tracks with Over 1 Billion Streams**
   - Selected tracks with more than 1,000,000,000 streams using a simple `WHERE` condition.
2. **Albums and Respective Artists**
   - Extracted distinct combinations of albums and artists.
3. **Total Comments on Licensed Tracks**
   - Summed all comments for tracks where `licensed = TRUE`.
4. **Tracks in Single-Type Albums**
   - Filtered tracks with `album_type = 'single'`.
5. **Track Count per Artist**
   - Counted the number of tracks released by each artist, sorted by most prolific.

------

## 🔸 Medium Level Analysis

1. **Average Danceability by Album**
   - Computed the mean `danceability` for each album using `AVG()` and `GROUP BY`.
2. **Top 5 Tracks by Energy**
   - Selected the 5 most energetic tracks using `MAX()` and ordering.
3. **Tracks with Official Video (Views & Likes)**
   - Aggregated views and likes for tracks marked as `official_video = TRUE`.
4. **Total Views per Album**
   - Calculated the total views per album by summing views grouped by album and track.
5. **Tracks Streamed More on Spotify Than YouTube**
   - Compared `stream` values for each platform using conditional aggregation and filtered tracks where Spotify outranked YouTube.

------

## 🔺 Advanced Level Analysis

1. **Top 3 Most-Viewed Tracks per Artist (Window Function)**
   - Used `DENSE_RANK()` with a `PARTITION BY artist` to find the top 3 tracks per artist by views.
2. **Tracks with Liveness Above Average**
   - Selected tracks where `liveness` is greater than the overall average.
3. **Energy Range per Artist**
   - Used a `WITH` clause to compute the difference between maximum and minimum `energy` for each artist.
4. **Tracks with Energy-to-Liveness Ratio > 1.2**
   - Retrieved tracks where `energy_liveness` (a derived ratio column) exceeds 1.2.
5. **Cumulative Likes Ordered by Views (Window Function)**
   - Calculated a running total of likes using `SUM(likes) OVER (ORDER BY views DESC)` to understand popularity over exposure.

------

## 📊 Key Insights

- A significant number of tracks crossed the **1 billion stream** milestone.
- **Official videos** tend to attract higher likes and views.
- Some artists consistently produce **high-energy** or **high-danceability** tracks.
- Tracks with a high **energy-to-liveness** ratio may reflect more studio-controlled production than live feel.
- Using **window functions** allowed granular analysis like **ranking** and **cumulative sums** without losing row-level detail.

------

## 💡 Recommendations for Improvement

- Normalize the dataset by separating tracks, albums, and artists into distinct related tables.
- Visualize key insights using tools like Power BI or Tableau for easier communication.
- Explore more behavioral metrics such as skip rates, repeat plays, or listener demographics (if available).
- Apply machine learning models for popularity prediction or genre classification using this structured data.

------

