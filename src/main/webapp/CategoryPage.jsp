<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Recipe Categories</title>
<link href="https://fonts.googleapis.com/css2?family=Capriola&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">

<style>
    :root {
        --primary-color: #e40046;
        --secondary-color: #0BA5A5;
        --accent-color: #f50057;
        --light-bg: #F5F5F5;
        --white: #ffffff;
        --dark-text: #333333;
        --transition: all 0.3s ease;
    }
    
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }
    
    body {
        font-family: 'Capriola', sans-serif;
        background-color: var(--light-bg);
        color: var(--dark-text);
        line-height: 1.6;
        padding-bottom: 40px;
    }

    h2 {
        text-align: center;
        margin: 30px 0;
        font-size: 2.2rem;
        color: var(--primary-color);
        position: relative;
    }

    h2:after {
        content: '';
        display: block;
        width: 80px;
        height: 3px;
        background: var(--secondary-color);
        margin: 10px auto;
    }

    /* Category Grid */
    .category-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
        gap: 30px;
        padding: 20px 5%;
        max-width: 1400px;
        margin: 0 auto;
    }

    /* Category Card */
    .category-card {
        background: var(--white);
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        transition: var(--transition);
        position: relative;
    }

    .category-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 15px 30px rgba(0,0,0,0.15);
    }

    .category-img {
        width: 100%;
        height: 250px;
        object-fit: cover;
        display: block;
    }

    .category-content {
        padding: 20px;
        text-align: center;
    }

    .category-title {
        font-size: 1.3rem;
        margin-bottom: 15px;
        color: var(--dark-text);
    }

    /* Button */
    .category-btn {
        display: inline-block;
        background-color: var(--secondary-color);
        color: var(--white);
        padding: 12px 28px;
        border: none;
        border-radius: 5px;
        font-size: 1rem;
        cursor: pointer;
        width: 100%;
        text-align: center;
        transition: var(--transition);
        font-weight: bold;
    }

    .category-btn:hover {
        background-color: #0a8f8f;
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    .category-btn a {
        color: var(--white);
        text-decoration: none;
        display: block;
    }

}

    /* Responsive Adjustments */
    @media (max-width: 992px) {
        .category-grid {
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        }
    }

    @media (max-width: 768px) {
        h2 {
            margin-top: 50px;
        }
        
        .category-grid {
            grid-template-columns: 1fr;
            max-width: 500px;
        }
    }

    /* Animations */
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .animate-delay-1 {
        animation-delay: 0.1s;
    }

    .animate-delay-2 {
        animation-delay: 0.2s;
    }

    .animate-delay-3 {
        animation-delay: 0.3s;
    }

    .animate-delay-4 {
        animation-delay: 0.4s;
    }

    .animate-delay-5 {
        animation-delay: 0.5s;
    }

    .animate-delay-6 {
        animation-delay: 0.6s;
    }

    .animate-delay-7 {
        animation-delay: 0.7s;
    }

    .animate-delay-8 {
        animation-delay: 0.8s;
    }

    .animate-delay-9 {
        animation-delay: 0.9s;
    }
</style>
</head>
<body>
<%@ include file = "BackButton.jsp" %>

    <h2 class="animate__animated animate__fadeIn">Recipe Categories</h2>
    
    <div class="category-grid">
        <!-- Row 1 -->
        <div class="category-card animate__animated animate__fadeInUp animate-delay-1">
            <img src="https://files.mob-cdn.co.uk/collections/Healthy-Vegetarian-Recipes.jpg" alt="Vegetarian Recipes" class="category-img">
            <div class="category-content">
                <h3 class="category-title">Vegetarian Recipes</h3>
                <button class="category-btn"><a href="RecipeServlet?category=Vegetarian">Explore</a></button>
            </div>
        </div>
        
        <div class="category-card animate__animated animate__fadeInUp animate-delay-2">
            <img src="https://i.ytimg.com/vi/2u983B2wD1k/maxresdefault.jpg" alt="Non-Vegetarian Recipes" class="category-img">
            <div class="category-content">
                <h3 class="category-title">Non-Vegetarian Recipes</h3>
                <button class="category-btn"><a href="RecipeServlet?category=Non-Vegetarian">Explore</a></button>
            </div>
        </div>
        
        <div class="category-card animate__animated animate__fadeInUp animate-delay-3">
            <img src="https://www.pamelasproducts.com/cdn/shop/files/PanPancakeMix.jpg?v=1694125550" alt="Baking Recipes" class="category-img">
            <div class="category-content">
                <h3 class="category-title">Baking Recipes</h3>
                <button class="category-btn"><a href="RecipeServlet?category=Baking">Explore</a></button>
            </div>
        </div>
        
        <!-- Row 2 -->
        <div class="category-card animate__animated animate__fadeInUp animate-delay-4">
            <img src="https://www.parents.com/thmb/Pu3l5Cg8PfvKgbaF333cvOoSjHM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Parents-PRT-hassle-free-party-food-ideas-kids-will-love-that-wont-break-your-budget-Rachel-Vanni-hero-977-fc9760f172cf4c029ea71cb9c8935419.jpg" alt="Party Recipes" class="category-img">
            <div class="category-content">
                <h3 class="category-title">Party Recipes</h3>
                <button class="category-btn"><a href="RecipeServlet?category=Party">Explore</a></button>
            </div>
        </div>
        
        <div class="category-card animate__animated animate__fadeInUp animate-delay-5">
            <img src="https://www.allrecipes.com/thmb/XgWHycCFMP4eAvMfKXnX3pzC_DA=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/ALR-14452-green-salad-VAT-hero-4x3-22eb1ac6ccd14e5bacf18841b9672313.jpg" alt="Salad Recipes" class="category-img">
            <div class="category-content">
                <h3 class="category-title">Salad Recipes</h3>
                <button class="category-btn"><a href="RecipeServlet?category=Salad">Explore</a></button>
            </div>
        </div>
        
        <div class="category-card animate__animated animate__fadeInUp animate-delay-6">
            <img src="https://tb-static.uber.com/prod/image-proc/processed_images/8090beef6c8cd61a9c4c7ade90a08a91/445a4b2618e10f7db95d4f17a85b117d.jpeg" alt="Dessert Recipes" class="category-img">
            <div class="category-content">
                <h3 class="category-title">Dessert Recipes</h3>
                <button class="category-btn"><a href="RecipeServlet?category=Desserts">Explore</a></button>
            </div>
        </div>
        
        <!-- Row 3 -->
        <div class="category-card animate__animated animate__fadeInUp animate-delay-7">
            <img src="https://www.whiskaffair.com/wp-content/uploads/2016/08/Clear-Chicken-Soup-2-3.jpg" alt="Soup Recipes" class="category-img">
            <div class="category-content">
                <h3 class="category-title">Soup Recipes</h3>
                <button class="category-btn"><a href="RecipeServlet?category=Soup">Explore</a></button>
            </div>
        </div>
        
        <div class="category-card animate__animated animate__fadeInUp animate-delay-8">
            <img src="https://hips.hearstapps.com/hmg-prod/images/harvest-bowls-index-66b3f14d6d5d4.jpg?crop=0.502xw:1.00xh;0,0&resize=640:*" alt="Healthy Meals" class="category-img">
            <div class="category-content">
                <h3 class="category-title">Healthy Meals</h3>
                <button class="category-btn"><a href="RecipeServlet?category=Healthy">Explore</a></button>
            </div>
        </div>
        
        <div class="category-card animate__animated animate__fadeInUp animate-delay-9">
            <img src="https://www.vikhrolicucina.com/uploads/stories/1662465216_groupindianassortedsweetsmithaiwithdiya.jpg" alt="Sweets Recipes" class="category-img">
            <div class="category-content">
                <h3 class="category-title">Sweets Recipes</h3>
                <button class="category-btn"><a href="RecipeServlet?category=Sweets">Explore</a></button>
            </div>
        </div>
    </div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // Animate elements when they come into view
    const animateOnScroll = function() {
        const elements = document.querySelectorAll('.animate__animated');
        
        elements.forEach(element => {
            const elementPosition = element.getBoundingClientRect().top;
            const windowHeight = window.innerHeight;
            
            if (elementPosition < windowHeight - 100) {
                const animationClass = element.classList[1];
                element.classList.add(animationClass);
            }
        });
    };
    
    // Run once on load and then on scroll
    animateOnScroll();
    window.addEventListener('scroll', animateOnScroll);
});
</script>

</body>
</html>