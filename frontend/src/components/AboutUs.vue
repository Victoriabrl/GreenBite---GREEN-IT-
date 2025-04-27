<template>
    <div class="about-us">
        <h1>About GreenBite</h1>
        <div class="mission-container">
            <p class="mission">
                GreenBite is a sustainable marketplace connecting eco-conscious consumers 
                with local vendors who want to reduce food waste by selling their surplus 
                fruits and vegetables at affordable prices.
            </p>
        </div>

        <div class="team-container">
            <h2>Our Team</h2>
            <div class="team-members">
                <div class="team-member">
                    <h3>Victoria</h3>
                    <p>Project Manager and developper</p>
                    <a href="https://github.com/Victoriabrl" target="_blank" rel="noopener noreferrer">
                        GitHub Profile
                    </a>
                </div>
                <div class="team-member">
                    <h3>Hormone</h3>
                    <p>Lead Developer (Fullstack) and structure engineer</p>
                    <a href="https://github.com/Hormone4" target="_blank" rel="noopener noreferrer">
                        GitHub Profile
                    </a>
                </div>
                <div class="team-member">
                    <h3>Eikko</h3>
                    <p>UI/UX Designer and Green IT Advocate</p>
                    <a href="https://github.com/Eikk-o" target="_blank" rel="noopener noreferrer">
                        GitHub Profile
                    </a>
                </div>
                <div class="team-member">
                    <h3>Nastrau</h3>
                    <p>Sustainability Expert and Performance Auditor</p>
                </div>
            </div>
        </div>

        <div class="eco-friendly-note">
            <h2>Our Commitment to Green IT</h2>
            <p>
                This website is designed with sustainability in mind. We've implemented:
            </p>
            <ul>
                <li>Minimalist design to reduce data transfer</li>
                <li>Optimized images and resources</li>
                <li>Efficient code to reduce server processing</li>
                <li>Carbon-aware hosting solutions</li>
            </ul>
        </div>
    </div>
</template>

<script>
    export default {
        name: 'AboutUs'
    }
</script>

<style scoped>
    .about-us {
        max-width: 1000px;
        margin: 0 auto;
        padding: 2rem;
        color: #333;
    }

    h1 {
        color: #2c8c3c;
        margin-bottom: 2rem;
        text-align: center;
    }

    h2 {
        color: #2c8c3c;
        margin: 1.5rem 0 1rem;
    }

    .mission-container {
        margin-bottom: 2rem;
    }

    .mission {
        font-size: 1.2rem;
        line-height: 1.6;
        text-align: center;
    }

    .values-list {
        line-height: 1.8;
    }

    .team-members {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-around;
        gap: 2rem;
        margin-top: 1.5rem;
    }

    .team-member {
        flex-basis: 250px;
        padding: 1.5rem;
        border-radius: 8px;
        background-color: rgba(232, 245, 233, 0.5);
        /*box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease;*/
        border: 1px solid #ddd;
    }

    .team-member h3 {
        margin-top: 0;
        color: #2c8c3c;
    }

    .team-member a {
        display: inline-block;
        margin-top: 10px;
        color: #2c8c3c;
        text-decoration: none;
        border-bottom: 1px solid #2c8c3c;
        padding-bottom: 2px;
        /*transition: color 0.3s ease;*/
    }

    .team-member a:hover {
        color: #1a5e28;
    }

    .eco-friendly-note {
        margin-top: 3rem;
        padding: 1.5rem;
        background-color: rgba(232, 245, 233, 0.5);
        border-radius: 8px;
    }

    .eco-friendly-note ul {
        list-style-type: none;
        padding-left: 0;
    }
</style>